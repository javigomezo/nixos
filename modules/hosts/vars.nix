{
  flake.modules.homeManager.vars = {lib, ...}: {
    options.my.vars = {
      dockerVolumes = lib.mkOption {
        type = lib.types.str;
        default = "/opt/docker";
      };
      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "Europe/Madrid";
      };
      wallpaper = lib.mkOption {
        type = lib.types.str;
      };
      glVendor = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      gbmBackend = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      libva_driver = lib.mkOption {
        type = lib.types.str;
      };
      mainInterface = lib.mkOption {
        type = lib.types.str;
      };
    };
    # wallpaper = "space.png";
    # libva_driver = "nvidia";
    # thermal_zone = 1;
    # hostname = "workstation";
  };
}
