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

    firefox-cascade-theme = { url = "github:andreasgrafen/cascade"; flake = false; };
    #hyprpaper.url = "github:hyprwm/hyprpaper";
  };
  outputs = { nixpkgs, home-manager, lanzaboote, agenix, ... }@inputs: {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      workstation = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./machines/workstation
          ./secrets
          agenix.nixosModules.default
          lanzaboote.nixosModules.lanzaboote
          ({ pkgs, lib, ... }: {
            environment.systemPackages = [
              # For debugging and troubleshooting Secure Boot.
              pkgs.sbctl
              agenix.packages.x86_64-linux.default
            ];
            boot.loader.systemd-boot.enable = lib.mkForce false;
            boot.lanzaboote = {
              enable = true;
              pkiBundle = "/etc/secureboot";
            };
          })
        ];
      };
      pi3b = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./machines/pi3b
          ./secrets
          agenix.nixosModules.default
          ({ pkgs, lib, ... }: {
            environment.systemPackages = [
              agenix.packages.aarch64-linux.default
            ];
          })
        ];
      };
    };

    homeConfigurations = {
      "javier@workstation" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}
