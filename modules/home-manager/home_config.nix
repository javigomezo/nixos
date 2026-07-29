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
    "javier@nuc8i3beh" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
      modules = [
        self.modules.homeManager.nuc8i3behConfiguration
      ];
    };
    "javier@pi4b" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages."aarch64-linux";
      modules = [
        self.modules.homeManager.pi4bConfiguration
      ];
    };
  };
}
