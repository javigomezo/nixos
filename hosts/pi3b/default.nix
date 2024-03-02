{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.age
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ./hardware-configuration.nix
    ./firewall.nix
    ./gpio.nix
    ../common/locale.nix
    ../common/nix.nix
    ../../users/javier
    ../../services/openssh
    ../../services/keepalived
    ../../services/adguardhome
    ../../services/tvheadend
  ];
  age = {
    identityPaths = ["/home/javier/.ssh/id_ed25519"];
    secrets.wifi = {
      file = ../../secrets/wifi.age;
    };
  };

  boot = {
    loader = {
      # NixOS wants to enable GRUB by default
      grub.enable = false;
      # Enables the generation of /boot/extlinux/extlinux.conf
      generic-extlinux-compatible.enable = true;
    };
    initrd.kernelModules = ["vc4" "bcm2835_dma" "i2c_bcm2835"];
    kernelModules = ["bcm2835-v4l2" "xhci_pci" "usbhid" "usb_storage"];
    # kernelPackages = pkgs.linuxPackages_rpi4;
  };

  hardware = {
    enableRedistributableFirmware = true;
    firmware = [pkgs.wireless-regdb];
    raspberry-pi."4".i2c1.enable = true;
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = "*-rpi-*.dtb";
      overlays = [
        {
          name = "spi0-0cs.dtbo";
          dtboFile = "${pkgs.device-tree_rpi.overlays}/spi0-0cs.dtbo";
        }
        {
          name = "rpi-tv.dtbo";
          dtboFile = "${pkgs.device-tree_rpi.overlays}/rpi-tv.dtbo";
        }
      ];
    };
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
    #"/firmware" = {
    #  device = "/dev/disk/by-label/FIRMWARE";
    #  fsType = "vfat";
    #};
  };

  # Add wireless

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

  console.enable = false;
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    htop
    tmux
  ];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "24.05"; # Don't change this
}
