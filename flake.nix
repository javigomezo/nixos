{
  description = "Personal NixOS Flake";

  inputs = {
    # Official NixOS package source, using nixos-unstable branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
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

    bibata-modern-classic-hyprcursor = {
      url = "github:javigomezo/bibata-modern-classic-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    private-fonts = {
      url = "git+ssh://git@github.com/javigomezo/private-fonts.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # firefox-cascade-theme = {
    #   url = "github:andreasgrafen/cascade";
    #   flake = false;
    # };

    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    checks = forAllSystems (system: {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
        };
      };
    });
    devShells = forAllSystems (system: {
      default = nixpkgs.legacyPackages.${system}.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
      };
    });
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    homeManagerModules = import ./modules/home-manager;
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
      y520 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          vars = import ./hosts/y520/vars.nix;
        };
        modules = [
          ./hosts/y520
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
          inherit inputs outputs;
          vars = import ./hosts/workstation/vars.nix;
        };
        modules = [
          ./home-manager/workstation.nix
        ];
      };
      "javier@y520" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          vars = import ./hosts/y520/vars.nix;
        };
        modules = [
          ./home-manager/y520.nix
        ];
      };
      "vagrant@vagrantbox" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          vars = import ./hosts/y520/vars.nix;
        };
        modules = [
          ./home-manager/vagrantbox.nix
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
