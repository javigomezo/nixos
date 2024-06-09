{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.age
    inputs.disko.nixosModules.disko
    inputs.impermanence.nixosModules.impermanence
    ./disko
    ./firewall.nix
    ./fonts.nix
    ./impermanence
    ./locale.nix
    ./nas.nix
    ./nh.nix
    ./nix.nix
    ./nixpkgs.nix
    ./tailscale.nix
    ../../users/javier
    ../../services/openssh
  ];

  programs = {
    git.enable = true;
    zsh.enable = true;
    nix-ld = {
      enable = true;
      libraries = [];
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = "github:javigomezo/nixos";
    allowReboot = true;
    rebootWindow = {
      lower = "05:00";
      upper = "07:00";
    };
    dates = "01:59"; # Because Nothing Good Happens After 2 A.M.
    persistent = true;
  };

  systemd = {
    targets.network-online.wantedBy = lib.mkForce []; # Normally ["multi-user.target"]
    services.NetworkManager-wait-online.wantedBy = lib.mkForce []; # Normally ["network-online.target"]
    services.systemd-udev-settle.enable = lib.mkForce false;
  };
}
