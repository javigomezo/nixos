{config, ...}: {
  sops = {
    secrets = {
      "rclone/provider" = {
        sopsFile = ../../hosts/common/secrets.yaml;
        format = "yaml";
      };
      "rclone/user" = {
        sopsFile = ../../hosts/common/secrets.yaml;
        format = "yaml";
      };
      "rclone/password" = {};
      "rclone/crypt_password" = {
        sopsFile = ../../hosts/common/secrets.yaml;
        format = "yaml";
      };
      "rclone/crypt_salt" = {
        sopsFile = ../../hosts/common/secrets.yaml;
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
      '';
    };
  };

  systemd.tmpfiles.rules = ["d /var/lib/rclone/cache 0775 root root - -"];
  fileSystems."/mnt/rclone" = {
    device = "drive_crypt:/";
    fsType = "rclone";
    depends = ["/home/javier"];
    options = [
      "noauto"
      "nodev"
      "nofail"
      "x-systemd.automount"
      "allow_other"
      "allow_non_empty"
      "args2env"
      "config=/home/javier/.config/rclone/rclone.conf"
      "cache-dir=/var/lib/rclone/cache/"
      "dir-cache-time=5000h"
      "user_agent=nucapi"
      "poll_interval=10s"
      "umask=002"
      "vfs-cache-mode=full"
      "vfs-fast-fingerprint"
      "vfs-cache-max-size=8G"
      "vfs-cache-max-age=5000h"
      "tpslimit=12"
      "tpslimit_burst=0"
    ];
  };
}
