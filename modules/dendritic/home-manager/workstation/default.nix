{
  self,
  inputs,
  ...
}: {
  flake.modules.homeManager.workstationHome = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
    modules = [self.modules.homeManager.workstationConfig];
  };
}
