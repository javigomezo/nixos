{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    inputs.impermanence.nixosModules.impermanence
    ./firewall.nix
    ./hardware-configuration.nix
    ./networking.nix
    ../common/impermanence
    ../common/sops.nix
    ../common/locale.nix
    ../common/nix.nix
    ../common/nixpkgs.nix
    ../common/tailscale.nix
    ../../services/openssh
    # ../../services/network/keepalived.nix
    ../../services/network/adguardhome
    ../../services/tvheadend
    ../../users/javier
  ];

  my = {
    impermanence = {
      enable = false;
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = "github:javigomezo/nixos#${config.networking.hostName}";
    allowReboot = true;
    rebootWindow = {
      lower = "01:00";
      upper = "05:00";
    };
    dates = "weekly";
    persistent = true;
  };

  # system.build.sdImage.compressImage = false;
  boot = {
    initrd.allowMissingModules = true;
    supportedFilesystems.zfs = lib.mkForce false;
    loader = {
      # NixOS wants to enable GRUB by default
      grub.enable = false;
      # Enables the generation of /boot/extlinux/extlinux.conf
      generic-extlinux-compatible.enable = true;
    };
    kernelParams = lib.mkAfter ["brcmfmac.roamoff=1" "brcmfmac.feature_disable=0x282000"];
    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
    "/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
  };

  hardware.bluetooth.enable = false;
  hardware.raspberry-pi."4".tv-hat.enable = true;

  console.enable = false;
  programs.zsh.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    htop
    tmux
  ];

  users.groups.spi = {};
  users.groups.gpio = {};

  services = {
    getty.autologinUser = "javier";
    tailscale.useRoutingFeatures = lib.mkForce "both";
    udev.extraRules = ''
      SUBSYSTEM=="spidev", KERNEL=="spidev0.0", GROUP="spi", MODE="0660"
      SUBSYSTEM=="bcm2835-gpiomem", KERNEL=="gpiomem", GROUP="gpio", MODE="0660"
      SUBSYSTEM=="gpio", KERNEL=="gpiochip*", GROUP="gpio",MODE="0660", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio  /sys/class/gpio/export /sys/class/gpio/unexport ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
      SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add",RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"
    '';
  };
  system.stateVersion = "24.05"; # Don't change this
}
