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
    ./backups.nix
    ./containers.nix
    ./networking.nix
    ../common
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

  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    tpm2-tss
    powertop
    sbctl
  ];

  fileSystems."/mnt/Qbittorrent" = {
    device = "/opt/docker-services/qbittorrent/data/downloads";
    options = ["bind"];
  };

  # List services that you want to enable:
  # Tell Xorg to use the nvidia driver
  services = {
    tailscale.useRoutingFeatures = lib.mkForce "both";
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
