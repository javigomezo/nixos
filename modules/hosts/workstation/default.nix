{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.workstation = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.autofirma-nix.nixosModules.default
      self.nixosModules.workstation
    ];
  };
}
