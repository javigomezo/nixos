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
    ./containers.nix
    ./backups.nix
    ../common
    ../../services/keepalived
    # ./power-management.nix
    ../optional/stylix.nix
  ];

  my = {
    boot.secureboot.enable = true;
    disko = {
      enable = true;
      encryption = false;
      device = "/dev/disk/by-id/nvme-nvme.c0a9-323130324534453441333533-435431303030503253534438-00000001";
    };
    impermanence = {
      enable = true;
      machine-id = "dde9c33d829d4e9db48682b3ea731cf9\n";
    };
    nas-mounts = {
      qbittorrent-mount.enable = false;
      nas-address = "11.0.0.1";
      seagate-mount = {
        device = "/dev/disk/by-uuid/6dfd6638-e78b-4913-8bd9-60940e152bfe";
        fsType = "ext4";
        options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=60"];
      };
    };
  };

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
  networking = {
    hostName = "nuc8i3beh";
    enableIPv6 = true;
    dhcpcd.enable = false;
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
      enp58s0u1 = {
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
    firewall = {
      allowedTCPPorts = [2049];
      # trustedInterfaces = ["enp58s0u1"];
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
    # docker = {
    #   autoPrune.enable = true;
    #   storageDriver = "btrfs";
    # };
    podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true;
      autoPrune.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  services.thermald.enable = true;
  services.upower.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    tpm2-tss
    powertop
    ethtool
    networkd-dispatcher
    sbctl
  ];

  fileSystems."/mnt/Qbittorrent" = {
    device = "/opt/docker-services/qbittorrent/data/downloads";
    options = ["bind"];
  };

  # List services that you want to enable:
  # Tell Xorg to use the nvidia driver
  services = {
    btrfs.autoScrub.enable = true;
    btrfs.autoScrub.interval = "weekly";
    dbus.enable = true;
    rpcbind.enable = true;
    nfs.server = {
      enable = true;
      exports = ''
        /mnt             10.0.0.0/24(rw,fsid=0,no_subtree_check)
        /mnt/Qbittorrent 10.0.0.0/24(rw,nohide,insecure,no_root_squash,no_subtree_check)
        /mnt/Seagate 10.0.0.0/24(rw,nohide,insecure,no_root_squash,no_subtree_check)
      '';
      hostName = "10.0.0.2";
    };
  };

  systemd.services."tailscale-optimization" = {
    wantedBy = ["multi-user.target"];
    after = ["graphical.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${lib.getExe pkgs.ethtool} -K eno1 rx-udp-gro-forwarding on rx-gro-list off";
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  services.undervolt = {
    enable = true;
    coreOffset = -30;
    gpuOffset = -30;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
