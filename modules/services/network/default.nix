{self, ...}: {
  flake.nixosModules.networkServices = {
    imports = with self.nixosModules; [
      adguardHome
      authelia
      cloudflareDyndns
      # ./keepalived.nix
      syncthing
      traefik
      # ./wireguard.nix
    ];
  };
}
