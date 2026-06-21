{
  self,
  inputs,
  ...
}: {
  flake.homeConfigurations."javier@workstation" = inputs.home-manager.lib.homeManagerConfiguration {
    extraSpecialArgs = {
      inherit inputs;
      outputs = self;
      vars = import ../../../hosts/workstation/vars.nix;
    };
    pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
    modules = [
      ../../../home-manager/workstation.nix
      self.modules.homeManager.cli
    ];
  };
}
