{ lib, config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./firewall.nix
      ../../users/javier
      ../../services/keepalived
      ../../services/adguardhome
    ];

  age.identityPaths = ["/home/javier/.ssh/id_ed25519"];
  age.secrets.wifi = {
    file = ../../secrets/wifi.age;
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    settings = {
      trusted-users = [ "javier" ];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };
  
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  # Add wireless
  hardware = {
    enableRedistributableFirmware = true;
    firmware = [ pkgs.wireless-regdb ];
  };

  # set up wireless static IP address
  networking = {
    wireless.enable = true;
    wireless.environmentFile = config.age.secrets.wifi.path;
    wireless.networks = {
      "@SSID@".psk = "@PSK@";
    };
    hostName = "pi3b";
    enableIPv6 = false;
    interfaces = {
      wlan0 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "10.0.0.3";
          prefixLength = 24;
        }];
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
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [  ];
    };
  };

  time.timeZone = "Europe/Madrid";
  i18n = {
    defaultLocale = "es_ES.UTF-8";
    extraLocaleSettings = {
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
  };
  console.keyMap = "es";


  hardware.bluetooth.enable = false;
  
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    htop
  ];

  # Services - SSH
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "24.05"; # Don't change this
}
