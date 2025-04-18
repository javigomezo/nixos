{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.powerManagement = {
    enable = lib.mkOption {
      description = "Enables power management";
      type = lib.types.bool;
      default = true;
    };
    isLaptop = lib.mkOption {
      description = "Is a laptop";
      type = lib.types.bool;
      default = false;
    };
    undervolt = {
      enable = lib.mkOption {
        description = "Enables undervolt";
        type = lib.types.bool;
        default = true;
      };
      coreOffset = lib.mkOption {
        description = "Undervolt core offset";
        type = lib.types.int;
        default = -60;
      };
      gpuOffset = lib.mkOption {
        description = "Undervolt gpu offset";
        type = lib.types.int;
        default = -40;
      };
    };
  };
  config = {
    environment.systemPackages = lib.mkIf config.my.powerManagement.enable [
      pkgs.powertop
    ];
    powerManagement = {
      enable = true;
      powertop.enable = config.my.powerManagement.enable;
    };

    services = {
      thermald.enable = true;
      upower.enable = true;
      undervolt = {
        enable = config.my.powerManagement.undervolt.enable;
        coreOffset = config.my.powerManagement.undervolt.coreOffset;
        gpuOffset = config.my.powerManagement.undervolt.gpuOffset;
      };
    };

    systemd.tmpfiles.settings = lib.mkIf config.my.powerManagement.isLaptop {
      "ideapad-set-conservation-mode" = {
        "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode" = {
          "f+" = {
            group = "root";
            user = "root";
            mode = "0644";
            argument = "1";
          };
        };
      };
    };
  };
}
