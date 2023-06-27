{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <home-manager/nixos>
      ./hardware-configuration.nix
    ];
  nix.settings.auto-optimise-store = true;

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

  home-manager.users.javier = { pkgs, ... }: {
    home.stateVersion = "23.05";
    home.packages = [  ];
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
  };

  hardware.bluetooth.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    #open = true; # If true breaks hyprland so...
    nvidiaSettings = false;
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
  
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ]; # Fixes workspaces
      });
    })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    bibata-cursors
    duf
    exa
    ffmpeg
    firefox-wayland
    hyprpaper
    grim
    killall
    lutris
    htop
    nitch
    mako
    pavucontrol
    (python3.withPackages(ps: with ps; [ requests]))
    libreoffice-qt
    slurp
    stow
    swaylock-effects
    tmux
    vim
    waybar
    wlogout
    wofi
    xfce.thunar
  ];

  environment.etc = let
    json = pkgs.formats.json {};
  in {
    "pipewire/pipewire.d/92-low-latency.conf".source = json.generate "92-low-latency.conf" {
      context.properties = {
        default.clock.allowed-rates = [ 44100 48000 96000 ];
        log.level = 4;
        default.clock.rate = 96000;
        default.clock.quantum = 256;
        default.clock.min-quantum = 256;
        default.clock.max-quantum = 4092;
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "javigomezo";
  };
  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = false;
    };
    nvidiaPatches = true;
  };

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  programs.zsh.enable = true;
  
  fonts = {
    fonts = with pkgs; [
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ];})
    ];
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    enableDefaultFonts = true;
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
    alsa.enable = false;
    alsa.support32Bit = true;
    pulse.enable = true;
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
