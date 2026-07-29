{self, ...}: {
  flake.nixosModules.nuc8i3behServices = {
    imports = with self.nixosModules; [
      networkServices
      homeServices
      mediaServices
      otherServices
    ];

    virtualisation = {
      oci-containers.backend = "podman";
      podman = {
        enable = true;
        dockerSocket.enable = true;
        dockerCompat = true;
        autoPrune.enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
