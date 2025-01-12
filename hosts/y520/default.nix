{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-pc-laptop-hdd
    inputs.lanzaboote.nixosModules.lanzaboote
    ./hardware-configuration.nix
    ./power-management.nix
    ./usbguard.nix
    ../common
    ../optional/display_manager.nix
    ../optional/nvidia.nix
    ../optional/pipewire.nix
    ../optional/steam.nix
    ../optional/stylix.nix
  ];

  my = {
    disko = {
      enable = true;
      encryption = true;
      device = "/dev/disk/by-id/nvme-Samsung_SSD_960_EVO_250GB_S3ESNX0JB10293D";
    };

    impermanence = {
      enable = true;
      machine-id = "0838f4c362294859ab2a451784b12b61\n";
    };
    boot = {
      loader.timeout = 0;
      secureboot.enable = true;
    };
    nvidia.prime.enable = true;
  };

  networking = {
    hostName = "y520";
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
      interface = "wlp3s0";
    };
    nameservers = ["10.0.0.200" "10.0.0.3"];
    # Enable networking
    networkmanager.enable = true;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        #intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libvdpau-va-gl
      ];
      #extraPackages32 = with pkgs.pkgsi686Linux; [intel-vaapi-driver];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.brightnessctl
    pkgs.intel-gpu-tools
    pkgs.sbctl
    pkgs.tpm2-tss
  ];

  programs = {
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
    btrfs.autoScrub.interval = "weekly";
    flatpak.enable = true;
    gvfs.enable = true; # Thunar Mount, trash etc
    tumbler.enable = true; # Thumbnail support for images
    dbus.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.systemd-udev-settle.enable = false;

  security = {
    polkit.enable = true;
    pam.services.hyprlock = {};
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
  system.stateVersion = "24.05"; # Did you read the comment?
}
