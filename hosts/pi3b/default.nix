{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.nixos-hardware.nixosModules.raspberry-pi-3
    inputs.impermanence.nixosModules.impermanence
    ./hardware-configuration.nix
    ./firewall.nix
    ./gpio.nix
    ../common/impermanence
    ../common/sops.nix
    ../common/locale.nix
    ../common/nix.nix
    ../../users/javier
    ../../services/openssh
    ../../services/keepalived
    ../../services/network/adguardhome
    #../../services/tvheadend
  ];

  my = {
    impermanence = {
      enable = false;
    };
  };

  sops = {
    secrets = {
      home_ssid = {};
      home_psk = {};
    };
    templates."networks.conf" = {
      owner = "root";
      group = "root";
      mode = "0400";
      path = "/etc/wpa_supplicant.conf";
      content = ''
        network={
          ssid="${config.sops.placeholder.home_ssid}"
          psk="${config.sops.placeholder.home_psk}"
        }
      '';
    };
  };

  boot = {
    loader = {
      # NixOS wants to enable GRUB by default
      grub.enable = false;
      # Enables the generation of /boot/extlinux/extlinux.conf
      generic-extlinux-compatible.enable = true;
    };
    kernelModules = ["spi_bcm2835" "spidev"];
  };

  hardware = {
    enableRedistributableFirmware = true;
    deviceTree = {
      enable = true;
      filter = "*rpi*.dtb";
      overlays = [
        {
          name = "rpi-tv";
          dtboFile = "${pkgs.device-tree_rpi.overlays}/rpi-tv.dtbo";
        }
        {
          name = "spi0-0cs.dtbo";
          dtboFile = "${pkgs.device-tree_rpi.overlays}/spi0-0cs.dtbo";
        }
        {
          name = "ssd1306-spi.dtbo";
          dtboFile = "${pkgs.device-tree_rpi.overlays}/ssd1306-spi.dtbo";
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
    "/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
  };

  # Add wireless

  # set up wireless static IP address
  networking = {
    wireless = {
      enable = true;
      allowAuxiliaryImperativeNetworks = true;
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

  users.groups.spi = {};
  services.udev.extraRules = ''
    KERNEL=="gpiochip0*", GROUP="wheel", MODE="0660"
    SUBSYSTEM=="spidev", KERNEL=="spidev0.0", GROUP="spi", MODE="0660"
  '';
  system.stateVersion = "24.05"; # Don't change this
}
