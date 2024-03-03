{
  description = "Personal NixOS Flake";

  inputs = {
    # Official NixOS package source, using nixos-unstable branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-cascade-theme = {
      url = "github:andreasgrafen/cascade";
      flake = false;
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #hyprpaper.url = "github:hyprwm/hyprpaper";
  };
  outputs = {nixpkgs, ...} @ inputs: {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      workstation = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          vars = import ./hosts/workstation/vars.nix;
        };
        modules = [
          ./hosts/workstation
          ./secrets
        ];
      };
      pi3b = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
          vars = import ./hosts/pi3b/vars.nix;
        };
        modules = [
          ./hosts/pi3b
          ./secrets
        ];
      };
    };

    # home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "javier@workstation" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs;
          vars = import ./hosts/workstation/vars.nix;
        };
        modules = [
          ./home-manager/workstation.nix
        ];
      };
      "javier@pi3b" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {
          inherit inputs;
          vars = import ./hosts/pi3b/vars.nix;
        };
        modules = [
          ./home-manager/pi3b.nix
        ];
      };
    };
  };
}
