{
  self,
  inputs,
  ...
}: {
  flake.modules.homeManager.y520Home = inputs.home-manager.lib.homeManagerConfiguration {
    extraSpecialArgs = {
      inherit inputs;
      outputs = self;
      vars = import ../../../../hosts/y520/vars.nix;
    };
    pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
    modules = [
      ../../../../home-manager/y520.nix
      self.modules.homeManager.nixvim
      # self.modules.homeManagerModules.workstationConfiguration
    ];
  };
}
