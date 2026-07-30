{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.pi4b = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.pi4b];
  };
}
