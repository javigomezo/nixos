{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.workstation = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.workstation];
  };
}
