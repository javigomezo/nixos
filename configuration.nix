{ inputs, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.enableIPv6 = false;
  networking.interfaces.wlo1.ipv4.addresses = [{
    address = "10.0.0.10";
    prefixLength = 24;
  }];
  networking.nameservers = ["10.0.0.200" "10.0.0.2"];

  # Enable networking
  networking.networkmanager.enable = true;

  fileSystems."/mnt/Downloads" = 
    {
      device = "/dev/disk/by-partuuid/ca8d8d5f-01";
      fsType = "ntfs3";
      options = [ "rw" "uid=1000"];
    };

  fileSystems."/mnt/Qbittorrent" = 
    {
      device = "10.0.0.2:/home/javier/docker-services/qbittorrent/data/downloads";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60" ];
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

  # Configure keymap in X11
  services.xserver = {
    layout = "es";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "es";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.javier = {
    isNormalUser = true;
    description = "javier";
    shell = pkgs.zsh;
    extraGroups = [ "disk" "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;

  hardware.nvidia = {
    modesetting.enable = true;
    #open = true; # If true breaks hyprland so...
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  #Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    bibata-cursors
    duf
    exa
    firefox-wayland
    ffmpeg
    gamescope
    git
    grim
    hyprpaper
    killall
    lutris
    htop
    nitch
    nordic
    mako
    mangohud
    mpv
    pavucontrol
    polkit-kde-agent
    protonup-qt
    (python3.withPackages(ps: with ps; [ requests]))
    libreoffice-qt
    rofi-wayland-unwrapped
    slurp
    stow
    swaylock-effects
    tmux
    vim
    #vulkan-tools
    waynergy
    wl-clipboard
    wlogout
    xfce.thunar
  ];

  #programs.hyprland.package = null;

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
       mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
  };

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  programs.zsh.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
  };
  
  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      font-awesome
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ];})
    ];
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
        antialias = true;
        hinting.enable = true;
        defaultFonts = {
          monospace = [ "NerdFontsSymbolsOnly" "Noto Mono" ];
          emoji = [ "Noto Color Emoji" "Twitter Color Emoji" "JoyPixels" "Unifont" "Unifont Upper" ];
        };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # Tell Xorg to use the nvidia driver
  services.xserver.videoDrivers = ["nvidia"];
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "javier";
  services.flatpak.enable = true;
  services.gvfs.enable = true; # Thunar Mount, trash etc
  services.tumbler.enable = true; # Thumbnail support for images
  services.dbus.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
    wireplumber.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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
