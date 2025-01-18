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

  fileSystems."/mnt/rclone" = {
    device = "drive_crypt:/";
    fsType = "rclone";
    depends = ["/home/javier"];
    options = [
      "noauto"
      "nofail"
      "x-systemd.automount"
      "allow_other"
      "args2env"
      "allow_non_empty"
      "dir_cache_time=5000h"
      "user_agent=nucapi"
      "poll_interval=10s"
      "umask=002"
      "cache_dir=/var/lib/rclone/cache/"
      "vfs_cache_mode=full"
      "vfs_cache_max_size=8G"
      "vfs_fast_fingerprint"
      "vfs_cache_max_age=5000h"
      "tpslimit=12"
      "tpslimit_burst=0"
      "config=/home/javier/.config/rclone/rclone.conf"
    ];
  };
}
