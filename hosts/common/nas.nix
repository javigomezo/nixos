{
  fileSystems = {
      "/mnt/Qbittorrent" = {
        device = "10.0.0.2:/home/javier/docker-services/qbittorrent/data/downloads";
        fsType = "nfs";
        options = ["nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60"];
      };
  
      "/mnt/TVShows" = {
        device = "10.0.0.4:/mnt/main_storage/tvshows";
        fsType = "nfs";
        options = ["nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60"];
      };
  
      "/mnt/Movies" = {
        device = "10.0.0.4:/mnt/main_storage/movies";
        fsType = "nfs";
        options = ["nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60"];
      };
    };
}
