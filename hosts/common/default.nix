{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.age
    inputs.disko.nixosModules.disko
    ./disko
    ./firewall.nix
    ./fonts.nix
    ./locale.nix
    ./nas.nix
    ./nh.nix
    ./nix.nix
    ./nixpkgs.nix
    ./tailscale.nix
    ../../services/openssh
  ];

  programs = {
    git.enable = true;
    zsh.enable = true;
  };

  system.autoUpgrade = {
    enable = true;
    flake = "github:javigomezo/nixos";
    allowReboot = true;
    dates = "01:59"; # Because Nothing Good Happens After 2 A.M.
  };

  systemd = {
    targets.network-online.wantedBy = lib.mkForce []; # Normally ["multi-user.target"]
    services.NetworkManager-wait-online.wantedBy = lib.mkForce []; # Normally ["network-online.target"]
    services.systemd-udev-settle.enable = lib.mkForce false;
  };
}
