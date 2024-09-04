{
  lib,
  pkgs,
  config,
  ...
}: {
  options.my.boot = {
    loader = {
      timeout = lib.mkOption {
        description = "Boot timeout";
        type = lib.types.int;
        default = 10;
      };
    };
    nvidia = {
      enable = lib.mkEnableOption {
        description = "Enables nvidia";
        type = lib.types.bool;
        default = true;
      };
    };
    secureboot = {
      enable = lib.mkEnableOption {
        description = "Enables secureboot";
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = {
    boot = {
      kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
      supportedFilesystems = ["btrfs" "ntfs"];
      loader = {
        timeout = config.my.boot.loader.timeout;
        systemd-boot.enable = lib.mkForce (!config.my.boot.secureboot.enable);
        systemd-boot.configurationLimit = 10;
        efi.canTouchEfiVariables = true;
      };
      lanzaboote = {
        enable = config.my.boot.secureboot.enable;
        pkiBundle = "/etc/secureboot";
      };
      plymouth = {
        enable = true;
        # theme = "circle_flow";
        # themePackages = [(pkgs.adi1090x-plymouth-themes.override {selected_themes = ["circle_flow"];})];
      };
      consoleLogLevel = 0;
      initrd = {
        verbose = false;
        systemd.enable = true;
      };
      kernelParams =
        [
          "quiet"
          "loglevel=3"
          "systemd.show_status=auto"
          "udev.log_level=3"
          "rd.udev.log_level=3"
          "vt.global_cursor_default=0"
          "mem_sleep_default=deep"
          "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        ]
        ++ lib.optionals config.my.boot.nvidia.enable ["nvidia.NVreg_DynamicPowerManagement=0"];
      kernel.sysctl."net.core.rmem_max" = 7500000;
      kernel.sysctl."net.core.wmem_max" = 7500000;
      binfmt.emulatedSystems = ["aarch64-linux"]; # Emulate aarch64 for rpi
      blacklistedKernelModules = [
        "nouveau"
        "ideapad_laptop"
      ];
    };
  };
}