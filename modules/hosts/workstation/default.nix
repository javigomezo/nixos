{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.workstation = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.workstationConfiguration
    ];
  };
}
