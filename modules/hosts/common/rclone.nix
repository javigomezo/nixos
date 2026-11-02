{self, ...}: {
  flake.nixosModules.rclone = {
    config,
    pkgs,
    ...
  }: let
    mountOptions = [
      "noauto"
      "nofail"
      "_netdev"
      "nodev"
      "nosuid"
      "x-systemd.automount"
      "x-systemd.mount-timeout=30"
      "x-systemd.requires=network-online.target"
      "x-systemd.after=network-online.target"
      "allow_other"
      "fast-list"
      # "allow_non_empty"
      "args2env"
      "uid=1000"
      "gid=1000"
      "umask=002"
      "config=/home/javier/.config/rclone/rclone.conf"
      "user-agent=${config.networking.hostName}"

      "vfs-cache-mode=full"
      "vfs-cache-max-size=32G"
      "vfs-cache-min-free-space=10G"
      "vfs-cache-max-age=720h"
      "vfs-write-back=30s"
    ];
  in {
    environment.systemPackages = with pkgs; [
      rclone
    ];
    sops = {
      secrets = {
        "rclone/provider" = {
          sopsFile = self + "/modules/sops/common/_secrets.yaml";
          format = "yaml";
        };
        "rclone/provider_2" = {
          sopsFile = self + "/modules/sops/common/_secrets.yaml";
          format = "yaml";
        };
        "rclone/user" = {
          sopsFile = self + "/modules/sops/common/_secrets.yaml";
          format = "yaml";
        };
        "rclone/password" = {};
        "rclone/access_token" = {};
        "rclone/provider_2_root_folder_id" = {
          sopsFile = self + "/modules/sops/common/_secrets.yaml";
          format = "yaml";
        };
        "rclone/crypt_password" = {
          sopsFile = self + "/modules/sops/common/_secrets.yaml";
          format = "yaml";
        };
        "rclone/crypt_salt" = {
          sopsFile = self + "/modules/sops/common/_secrets.yaml";
          format = "yaml";
        };
        "rclone/crypt_password_2" = {
          sopsFile = self + "/modules/sops/common/_secrets.yaml";
          format = "yaml";
        };
        "rclone/crypt_salt_2" = {
          sopsFile = self + "/modules/sops/common/_secrets.yaml";
          format = "yaml";
        };
      };
      templates."rclone.conf" = {
        owner = "javier";
        path = "/home/javier/.config/rclone/rclone.conf";
        content = ''
          [drive]
            type = ${config.sops.placeholder."rclone/provider"}
            provider = ${config.sops.placeholder."rclone/provider"}
            user = ${config.sops.placeholder."rclone/user"}
            password = ${config.sops.placeholder."rclone/password"}

          [drive_crypt]
            type = crypt
            remote = drive:/backup
            password = ${config.sops.placeholder."rclone/crypt_password"}
            password2 = ${config.sops.placeholder."rclone/crypt_salt"}
                  
          [drive_2]
            type = ${config.sops.placeholder."rclone/provider_2"}
            access_token = ${config.sops.placeholder."rclone/access_token"}
            root_folder_id = ${config.sops.placeholder."rclone/provider_2_root_folder_id"}

          [drive_crypt_2]
            type = crypt
            remote = drive_2:/
            password = ${config.sops.placeholder."rclone/crypt_password_2"}
            password2 = ${config.sops.placeholder."rclone/crypt_salt_2"}
        '';
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/rclone/cache 0775 root root - -"
      "d /var/lib/rclone/cache_2 0775 root root - -"
    ];
    fileSystems."/mnt/rclone" = {
      device = "drive_crypt:/";
      fsType = "rclone";
      depends = ["/home/javier"];
      options =
        mountOptions
        ++ [
          "vfs-fast-fingerprint"
          "cache-dir=/var/lib/rclone/cache"
          "dir-cache-time=1h"
          "attr-timeout=1m"
          "tpslimit=12"
          "tpslimit-burst=20"
        ];
    };
    fileSystems."/mnt/rclone_2" = {
      device = "drive_crypt_2:/";
      fsType = "rclone";
      depends = ["/home/javier"];
      options =
        mountOptions
        ++ [
          "cache-dir=/var/lib/rclone/cache_2"
          "dir-cache-time=72h"
          "attr-timeout=72h"
          "tpslimit=4"
          "tpslimit-burst=8"
          "drime-upload-cutoff=128M"
        ];
    };
  };
}
