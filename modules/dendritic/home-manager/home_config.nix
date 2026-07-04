{
  self,
  inputs,
  ...
}: {
  flake.homeConfigurations = {
    "javier@workstation" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
      modules = [self.modules.homeManager.workstationConfig];
    };
    "javier@y520" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
      modules = [self.modules.homeManager.y520Config];
    };
    "javier@pi4b" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages."aarch64-linux";
      modules = [
        self.modules.homeManagerModules.pi4bConfiguration
      ];
    };
    "javier@nuc8i3beh" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
      modules = [
        self.modules.homeManagerModules.nuc8i3behConfiguration
      ];
    };
  };
}
