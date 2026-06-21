{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.workstation = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      # inherit inputs outputs;
      # vars = import ./hosts/workstation/vars.nix;
      vars = import ../../../../hosts/workstation/vars.nix;
    };
    modules = [
      self.nixosModules.workstationConfiguration
    ];
  };
}
