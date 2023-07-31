{
  description = "Personal NixOS Flake";

  inputs = {
    # Official NixOS package source, using nixos-unstable branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #hyprland = {
    #  url = "github:hyprwm/hyprpaper";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    #hyprpaper.url = "github:hyprwm/hyprpaper";
  };
  outputs = { nixpkgs, home-manager, ... }@inputs: {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
        ];
      };
    };

    #homeConfigurations = {
    #  "javier@nixos" = home-manager.lib.homeManagerConfiguration {
    #    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    #    extraSpecialArgs = { inherit inputs; };
    #    modules = [ ./home-manager/home.nix ];
    #  };
    #};
  };
}
