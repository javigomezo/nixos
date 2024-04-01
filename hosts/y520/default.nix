{
  inputs,
  system,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.age
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-pc-laptop-hdd
    # inputs.lanzaboote.nixosModules.lanzaboote
    ./hardware-configuration.nix
    ./disko.nix
    ./impermanence.nix
    ./firewall.nix
    ./udev.nix
    ../common
    ../optional/pipewire.nix
    ../optional/steam.nix
    ../../services/openssh
    ../../users/javier
  ];

  age = {
    # identityPaths = ["/home/javier/.ssh/id_ed25519"];
    secrets.wifi = {
      file = ../../secrets/wifi.age;
    };
  };

  boot = {
    supportedFilesystems = ["btrfs"];
    kernelParams = ["quiet" "loglevel=3" "systemd.show_status=auto" "udev.log_level=3" "rd.udev.log_level=3" "vt.global_cursor_default=0" "mem_sleep_default=deep"];
    consoleLogLevel = lib.mkForce 0;
    initrd.verbose = false;
    loader = {
      systemd-boot.enable = lib.mkForce true;
      systemd-boot.configurationLimit = 3;
      efi.canTouchEfiVariables = true;
    };
    # lanzaboote = {
    #   enable = true;
    #   pkiBundle = "/etc/secureboot";
    # };
    blacklistedKernelModules = ["nouveau"];
    # supportedFilesystems = ["ntfs"];
    binfmt.emulatedSystems = ["aarch64-linux"]; # Emulate aarch64 for rpi
  };

  networking = {
    wireless.environmentFile = config.age.secrets.wifi.path;
    wireless.networks = {
      "@SSID@".psk = "@PSK@";
    };
    hostName = "y520"; # Define your hostname.
    enableIPv6 = true;
    interfaces = {
      wlp3s0 = {
        useDHCP = lib.mkForce false;
        ipv4.addresses = [
          {
            address = "10.0.0.16";
            prefixLength = 24;
          }
        ];
      };
    };
    defaultGateway = {
      address = "10.0.0.1";
    };
    nameservers = ["10.0.0.200" "10.0.0.3"];
    # Enable networking
    networkmanager.enable = true;
  };

  fileSystems = {
    # "/mnt/Downloads" = {
    #   device = "/dev/disk/by-partuuid/ca8d8d5f-01";
    #   fsType = "ntfs3";
    #   options = ["rw" "uid=1000" "x-systemd.automount" "noauto"];
    # };

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
  };

  hardware = {
    bluetooth.enable = true;
    nvidia = {
      modesetting.enable = true;
      #open = true; # Only for newer cards
      nvidiaSettings = true;
      nvidiaPersistenced = true;
      powerManagement.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
    #Make sure opengl is enabled
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [vaapiVdpau nvidia-vaapi-driver];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    inputs.alejandra.defaultPackage.x86_64-linux
    inputs.agenix.packages.x86_64-linux.default
    pkgs.sbctl
    pkgs.lxqt.lxqt-policykit
  ];

  programs = {
    light.enable = true;
    zsh.enable = true;
    dconf.enable = true;
    xfconf.enable = true; # To save thunar changes
    thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      # font-awesome
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
    };
  };

  xdg.portal = {
    enable = true;
    configPackages = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # List services that you want to enable:
  # Tell Xorg to use the nvidia driver
  services = {
    blueman.enable = true;
    xserver.videoDrivers = ["nvidia"];
    xserver.enable = true;
    xserver.displayManager.sessionPackages = [pkgs.hyprland];
    xserver.displayManager.sddm.enable = true;
    xserver.displayManager.sddm.wayland.enable = true;
    xserver.displayManager.autoLogin.enable = true;
    xserver.displayManager.autoLogin.user = "javier";
    flatpak.enable = true;
    gvfs.enable = true; # Thunar Mount, trash etc
    tumbler.enable = true; # Thumbnail support for images
    dbus.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  security = {
    polkit.enable = true;
    pam.services.hyprlock = {};
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzu6WsnLgOJ4Oos1vf/+Fmwp714q/T4N+Qok93br0sK javier@nixos"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "24.05"; # Did you read the comment?
}
