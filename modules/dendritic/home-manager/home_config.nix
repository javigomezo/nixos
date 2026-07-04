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
    # "javier@pi4b" = inputs.home-manager.lib.homeManagerConfiguration {
    #   pkgs = inputs.nixpkgs.legacyPackages."aarch64-linux";
    #   modules = [
    #     ../../../home-manager/pi4b.nix
    #     self.modules.homeManager.nixvim
    #     self.modules.homeManagerModules.workstationConfiguration
    #   ];
    # };
    # "javier@nuc8i3beh" = inputs.home-manager.lib.homeManagerConfiguration {
    #   extraSpecialArgs = {
    #     inherit inputs;
    #     outputs = self;
    #     vars = import ../../../hosts/nuc8i3beh/vars.nix;
    #   };
    #   pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
    #   modules = [
    #     ../../../home-manager/nuc8i3beh.nix
    #     self.modules.homeManager.nixvim
    #     self.modules.homeManagerModules.workstationConfiguration
    #   ];
    # };
  };
}
