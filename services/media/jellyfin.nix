{
  lib,
  pkgs,
  ...
}: {
  # networking.firewall.interfaces.podman0.allowedTCPPorts = lib.mkAfter [32400];
  services.jellyfin = {
    enable = false;
    openFirewall = false;
    # accelerationDevices = ["/dev/dri/renderD128"];
    cacheDir = "/var/lib/jellyfin/cache";
  };
  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";
  environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
  environment.persistence."/persist".directories = lib.mkAfter [
    {
      directory = "/var/lib/jellyfin";
      user = "jellyfin";
      group = "jellyfin";
      mode = "u=rwx,g=rx,o=";
    }
  ];
}
