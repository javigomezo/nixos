{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.age
    ./hardware-configuration.nix
    ./firewall.nix
    ../../common/locale.nix
    ../../users/javier
    ../../services/openssh
    ../../services/keepalived
    ../../services/adguardhome
  ];

  age = {
    identityPaths = ["/home/javier/.ssh/id_ed25519"];
    secrets.wifi = {
      file = ../../secrets/wifi.age;
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    settings = {
      trusted-users = ["javier"];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/"
      ];
    };
  };

  boot = {
    loader = {
      # NixOS wants to enable GRUB by default
      grub.enable = false;
      # Enables the generation of /boot/extlinux/extlinux.conf
      generic-extlinux-compatible.enable = true;
      # raspberryPi = {
      #   enable = true;
      #   version = 3;
      # };
    };
    kernelModules = ["bcm2835-v4l2"];
    kernelPackages = pkgs.linuxPackages_rpi3;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  # Add wireless
  hardware = {
    enableRedistributableFirmware = true;
    firmware = [pkgs.wireless-regdb];
  };

  # set up wireless static IP address
  networking = {
    wireless.enable = true;
    wireless.environmentFile = config.age.secrets.wifi.path;
    wireless.networks = {
      "@SSID@".psk = "@PSK@";
    };
    hostName = "pi3b";
    enableIPv6 = true;
    interfaces = {
      wlan0 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "10.0.0.3";
            prefixLength = 24;
          }
        ];
      };
    };
    defaultGateway = {
      address = "10.0.0.1";
      interface = "wlan0";
    };
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
    ];

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [22];
      allowedUDPPorts = [];
    };
  };

  hardware.bluetooth.enable = false;

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    htop
    tmux
  ];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "24.05"; # Don't change this
}
