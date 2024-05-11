{
  inputs,
  pkgs,
  ...
}: {
  imports = [
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

  systemd = {
    targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce []; # Normally ["network-online.target"]
  };
}
