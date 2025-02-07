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
    seagate-mount.enable = lib.mkEnableOption {
      description = "Enables mounting of qbittorrent share";
      type = lib.types.bool;
      default = true;
    };
    nas-ip = lib.mkOption {
      description = "NAS IP address";
      type = lib.types.str;
      default = "10.0.0.4";
    };
  };
  config = lib.mkIf config.my.nas-mounts.enable {
    fileSystems = {
      "/mnt/Qbittorrent" = {
        device = "10.0.0.2:/home/javier/docker-services/qbittorrent/data/downloads";
        fsType = "nfs";
        options = ["nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60"];
      };

      "/mnt/Seagate" = {
        device = "10.0.0.2:/mnt/Seagate";
        fsType = "nfs";
        options = ["nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60"];
      };

      "/mnt/TVShows" = {
        device = "${config.my.nas-mounts.nas-ip}:/mnt/main_storage/tvshows";
        fsType = "nfs";
        options = ["nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60"];
      };

      "/mnt/Movies" = {
        device = "${config.my.nas-mounts.nas-ip}:/mnt/main_storage/movies";
        fsType = "nfs";
        options = ["nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60"];
      };
    };
  };
}
