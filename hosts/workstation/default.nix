{
  inputs,
  pkgs,
  vars,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.stylix.nixosModules.stylix
    ./hardware-configuration.nix
    ../common
    ../optional/display_manager.nix
    ../optional/pipewire.nix
    ../optional/steam.nix
    ../optional/retroarch.nix
    ../optional/nvidia.nix
    #../../services/network/traefik
    #../../services/network/authelia
  ];

  networking = {
    hostName = "workstation"; # Define your hostname.
    enableIPv6 = true;
    interfaces.wlo1 = {
      ipv4.addresses = [
        {
          address = "10.0.0.10";
          prefixLength = 24;
        }
      ];
      useDHCP = false;
    };
    nameservers = ["10.0.0.200" "10.0.0.2"];
    # Enable networking
    networkmanager.enable = true;
  };

  fileSystems = {
    "/mnt/Downloads" = {
      device = "/dev/disk/by-partuuid/ca8d8d5f-01";
      fsType = "ntfs3";
      options = ["rw" "uid=1000" "x-systemd.automount" "noauto"];
    };
  };

  hardware = {
    bluetooth.enable = true;
    graphics = {
      extraPackages = with pkgs; [vaapiVdpau nvidia-vaapi-driver];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.sbctl
    pkgs.git
    pkgs.opensc
  ];

  programs = {
    hyprland.enable = true;
    dconf.enable = true;
    xfconf.enable = true; # To save thunar changes
    thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  xdg.portal = {
    enable = true;
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # List services that you want to enable:
  # Tell Xorg to use the nvidia driver
  services = {
    blueman.enable = true;
    btrfs.autoScrub.enable = true;
    flatpak.enable = true;
    gvfs.enable = true; # Thunar Mount, trash etc
    pcscd.enable = true; # For smartcards
    tumbler.enable = true; # Thumbnail support for images
    dbus.enable = true;
    xserver.videoDrivers = ["nvidia"];
  };

  stylix = {
    enable = true;
    image = ../../home-manager/common/stylix/wallpapers/${vars.wallpaper};
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  # Fixes system immediately waking up from suspend (related to Gigabyte motherbouards)
  services.udev.extraRules = ''
    ACTION="add" SUBSYSTEM=="pci" ATTR{vendor}="0x1022" ATTR{device}="0x1483" ATTR{power/wakeup}="disabled"
  '';

  security = {
    polkit.enable = true;
    pam.services.hyprlock = {};
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
