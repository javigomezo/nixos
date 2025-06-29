{
  lib,
  config,
  ...
}: {
  options.my.nas-mounts = {
    enable = lib.mkOption {
      description = "Enables mounting of NAS shares";
      type = lib.types.bool;
      default = true;
    };
    qbittorrent-mount.enable = lib.mkEnableOption {
      description = "Enables mounting of qbittorrent share";
      type = lib.types.bool;
      default = true;
    };
    media-mount.enable = lib.mkEnableOption {
      description = "Enables mounting of qbittorrent share";
      type = lib.types.bool;
      default = true;
    };
    seagate-mount = {
      device = lib.mkOption {
        description = "Seagate device path";
        type = lib.types.str;
        default = "nuc8i3beh:/Seagate";
      };
      fsType = lib.mkOption {
        description = "Seagate filesystem type";
        type = lib.types.str;
        default = "nfs";
      };
      options = lib.mkOption {
        description = "Seagate mount options";
        type = lib.types.listOf lib.types.str;
        default = ["nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60"];
      };
    };

    nas-address = lib.mkOption {
      description = "NAS IP address";
      type = lib.types.str;
      default = "10.0.0.4";
    };
  };
  config = lib.mkIf config.my.nas-mounts.enable {
    fileSystems = {
      "/mnt/Qbittorrent" = lib.mkIf config.my.nas-mounts.qbittorrent-mount.enable {
        device = "nuc8i3beh:/Qbittorrent";
        fsType = "nfs";
        options = ["nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60"];
      };

      "/mnt/Seagate" = {
        device = config.my.nas-mounts.seagate-mount.device;
        fsType = config.my.nas-mounts.seagate-mount.fsType;
        options = config.my.nas-mounts.seagate-mount.options;
      };

      "/mnt/TVShows" = lib.mkIf config.my.nas-mounts.media-mount.enable {
        device = "${config.my.nas-mounts.nas-address}:/mnt/main_storage/tvshows";
        fsType = "nfs";
        options = ["nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60"];
      };

      "/mnt/Movies" = lib.mkIf config.my.nas-mounts.media-mount.enable {
        device = "${config.my.nas-mounts.nas-address}:/mnt/main_storage/movies";
        fsType = "nfs";
        options = ["nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60"];
      };
    };
  };
}
