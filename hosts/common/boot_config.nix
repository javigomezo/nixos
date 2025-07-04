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
      kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
      kernelModules = ["tcp_bbr"];
      kernel = {
        sysctl = {
          "net.ipv4.tcp_congestion_control" = "bbr";
          "net.core.default_qdisc" = "fq";
          "net.core.wmem_max" = 1073741824; # 1 GiB
          "net.core.rmem_max" = 1073741824; # 1 GiB
          "net.ipv4.tcp_rmem" = "4096 87380 1073741824"; # 1 GiB max
          "net.ipv4.tcp_wmem" = "4096 87380 1073741824"; # 1 GiB max
        };
      };
      #kernelPackages = pkgs.linuxPackages_6_10;
      supportedFilesystems = ["btrfs" "ntfs"];
      loader = {
        timeout = config.my.boot.loader.timeout;
        systemd-boot.enable = lib.mkForce (!config.my.boot.secureboot.enable);
        systemd-boot.configurationLimit = 10;
        systemd-boot.consoleMode = "max";
        efi.canTouchEfiVariables = true;
      };
      lanzaboote = {
        enable = config.my.boot.secureboot.enable;
        pkiBundle = "/var/lib/sbctl";
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

          # TODO: remove after https://github.com/NVIDIA/open-gpu-kernel-modules/pull/692
          # and similar are merged and build in nixpkgs-unstable.
          # WARNING: this disables tty output and thus hides boot logs.
          "initcall_blacklist=simpledrm_platform_driver_init"
        ]
        ++ lib.optionals config.my.boot.nvidia.enable ["nvidia.NVreg_DynamicPowerManagement=0"];
      binfmt.emulatedSystems = ["aarch64-linux"]; # Emulate aarch64 for rpi
      blacklistedKernelModules = [
        "nouveau"
        # "ideapad_laptop"
      ];
    };
  };
}
