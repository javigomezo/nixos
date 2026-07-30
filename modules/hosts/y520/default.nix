{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.y520 = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.y520];
  };
}
