{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.intel-nuc-8i7beh
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.lanzaboote.nixosModules.lanzaboote
    ./hardware-configuration.nix
    ../common
    # ./secrets.nix
    # ./power-management.nix
    ../optional/stylix.nix
  ];

  my = {
    boot.secureboot.enable = true;
    disko = {
      enable = true;
      encryption = false;
      device = "/dev/disk/by-id/nvme-Samsung_SSD_960_EVO_250GB_S3ESNX0JB10293D";
    };
    impermanence = {
      enable = true;
      machine-id = "dde9c33d829d4e9db48682b3ea731cf9\n";
    };
    nas-mounts = {
      qbittorrent-mount.enable = false;
      nas-ip = "11.0.0.1";
    };
    # stylix.enable = false;
  };

  boot = {
    supportedFilesystems = lib.mkForce ["btrfs"];
  };

  networking = {
    hostName = "nuc8i3beh";
    enableIPv6 = true;
    interfaces = {
      eno1 = {
        useDHCP = lib.mkForce false;
        ipv4.addresses = [
          {
            address = "10.0.0.2";
            prefixLength = 24;
          }
        ];
      };
      enx68da73abae92 = {
        useDHCP = lib.mkForce false;
        ipv4.addresses = [
          {
            address = "11.0.0.2";
            prefixLength = 24;
          }
        ];
        mtu = 9000;
      };
    };
    defaultGateway = {
      address = "10.0.0.1";
      interface = "eno1";
    };
    nameservers = ["9.9.9.11" "149.112.112.11"];
    # Enable networking
    networkmanager.enable = lib.mkForce false;
  };

  hardware = {
    bluetooth = {
      enable = false;
      powerOnBoot = false;
    };
  };

  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      dockerCompat = true;
      autoPrune.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.intel-gpu-tools
    pkgs.tpm2-tss
  ];

  # List services that you want to enable:
  # Tell Xorg to use the nvidia driver
  services = {
    btrfs.autoScrub.enable = true;
    btrfs.autoScrub.interval = "weekly";
    dbus.enable = true;
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
  system.stateVersion = "25.05"; # Did you read the comment?
}
