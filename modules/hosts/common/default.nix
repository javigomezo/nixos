{self, ...}: {
  flake.nixosModules.common = {
    config,
    lib,
    ...
  }: {
    imports = [
      self.modules.homeManager.vars
      self.nixosModules.bootConfig
      self.nixosModules.disko
      self.nixosModules.firewall
      self.nixosModules.fonts
      self.nixosModules.impermanence
      self.nixosModules.locale
      self.nixosModules.nas
      self.nixosModules.nh
      self.nixosModules.nix
      self.nixosModules.nixpkgs
      self.nixosModules.powerManagement
      self.nixosModules.rclone
      self.nixosModules.sops
      self.nixosModules.tailscale
      self.nixosModules.users
      self.nixosModules.openssh
    ];

    hardware.enableRedistributableFirmware = true;
    programs = {
      git.enable = true;
      zsh.enable = true;
      nix-ld = {
        enable = true;
        libraries = [];
      };
    };

    # home-manager = {
    #   useGlobalPkgs = true;
    #   useUserPackages = true;
    # };

    system.autoUpgrade = {
      enable = true;
      flake = "github:javigomezo/nixos#${config.networking.hostName}";
      allowReboot = true;
      rebootWindow = {
        lower = "01:30";
        upper = "05:00";
      };
      dates = "01:59"; # Because Nothing Good Happens After 2 A.M.
      persistent = true;
    };

    services = {
      gnome.gnome-keyring.enable = true;
      dbus = {
        enable = true;
        implementation = "broker";
      };
    };
    security.pam.services.greetd.enableGnomeKeyring = true;
    security.pam.services.login.enableGnomeKeyring = true;

    systemd = {
      targets.network-online.wantedBy = lib.mkForce []; # Normally ["multi-user.target"]
      services.NetworkManager-wait-online.wantedBy = lib.mkForce []; # Normally ["network-online.target"]
      services.systemd-udev-settle.enable = lib.mkForce false;
    };
  };
}
