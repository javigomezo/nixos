{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./locale.nix
    ./nas.nix
    ./nix.nix
    ./nixpkgs.nix
  ];

  systemd = {
    targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce []; # Normally ["network-online.target"]
  };
}
