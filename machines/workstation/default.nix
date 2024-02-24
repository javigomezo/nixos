{
  inputs,
  system,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    inputs.agenix.nixosModules.default
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.lanzaboote.nixosModules.lanzaboote
    ./hardware-configuration.nix
    ../../common/pipewire.nix
    ../../users/javier
  ];

  age.identityPaths = ["/home/javier/.ssh/id_ed25519"];

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      trusted-users = ["javier"];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = ["ntfs"];
    binfmt.emulatedSystems = ["aarch64-linux"]; # Emulate aarch64 for rpi
  };

  networking = {
    hostName = "workstation"; # Define your hostname.
    enableIPv6 = true;
    interfaces.wlo1.ipv4.addresses = [
      {
        address = "10.0.0.10";
        prefixLength = 24;
      }
    ];
    interfaces.wlo1.useDHCP = false;
    nameservers = ["10.0.0.200" "10.0.0.2"];

    # Enable networking
    networkmanager.enable = true;
  };

  fileSystems = {
    "/mnt/Downloads" = {
      device = "/dev/disk/by-partuuid/ca8d8d5f-01";
      fsType = "ntfs3";
      options = ["rw" "uid=1000"];
    };

    "/mnt/Qbittorrent" = {
      device = "10.0.0.2:/home/javier/docker-services/qbittorrent/data/downloads";
      fsType = "nfs";
      options = ["nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60"];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_ES.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "es";

  hardware = {
    bluetooth.enable = true;
    nvidia = {
      modesetting.enable = true;
      #open = true; # If true breaks hyprland so...
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
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
          ];
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    inputs.alejandra.defaultPackage.x86_64-linux
    inputs.agenix.packages.x86_64-linux.default
    pkgs.logiops
    pkgs.sbctl
  ];

  #programs.xwayland.package = true;

  programs = {
    zsh.enable = true;
    dconf.enable = true;
    thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
    steam = {
      enable = true;
      remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    };
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      font-awesome
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      defaultFonts = {
        monospace = ["NerdFontsSymbolsOnly" "Noto Mono"];
        emoji = ["Noto Color Emoji" "Twitter Color Emoji" "JoyPixels" "Unifont" "Unifont Upper"];
      };
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
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "23.05"; # Did you read the comment?
}
