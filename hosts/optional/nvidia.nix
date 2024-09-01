{
  config,
  lib,
  ...
}: {
  options.my.nvidia = {
    prime = {
      enable = lib.mkEnableOption {
        description = "Enables nvidia";
        type = lib.types.bool;
        default = false;
      };
    };
  };
  config = {
    hardware.nvidia = {
      modesetting.enable = true;
      open = false; # If true breaks hyprland so...
      nvidiaSettings = true;
      nvidiaPersistenced = true;
      powerManagement.enable = true;
      prime = {
        offload = {
          enable = config.my.nvidia.prime.enable;
          enableOffloadCmd = config.my.nvidia.prime.enable;
        };
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
