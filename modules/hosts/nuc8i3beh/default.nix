{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.nuc8i3beh = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.nuc8i3beh];
  };
}
