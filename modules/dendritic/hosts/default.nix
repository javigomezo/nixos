{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations = {
    workstation = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        self.nixosModules.workstation
      ];
    };
    y520 = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        self.nixosModules.y520
      ];
    };
    # nuc8i3beh = inputs.nixpkgs.lib.nixosSystem {
    #   modules = [
    #     self.nixosModules.nuc8i3beh
    #   ];
    # };
    # pi4b = inputs.nixpkgs.lib.nixosSystem {
    #   modules = [
    #     self.nixosModules.pi4b
    #   ];
    # };
  };
}
