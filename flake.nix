{
  description = "Personal NixOS Flake";

  inputs = {
    # Official NixOS package source, using nixos-unstable branch here
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
    nixpkgs-stable.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-25.11";
    #nixpkgs-mine.url = "github:javigomezo/nixpkgs";
    nixpkgs-mine.url = "git+https://github.com/javigomezo/nixpkgs?shallow=1";

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
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nur = {
      url = "github:nix-community/nur";
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

    nixvim = {
      url = "github:nix-community/nixvim";
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
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    linuxSystems = ["x86_64-linux" "aarch64-linux"];
    pkgsFor = lib.genAttrs linuxSystems (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.allowUnfreePredicate = _: true;
        }
    );
  in {
    checks = lib.genAttrs linuxSystems (system: {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
        };
      };
    });
    devShells = lib.genAttrs linuxSystems (system: {
      default = nixpkgs.legacyPackages.${system}.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
      };
    });
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    homeManagerModules = import ./modules/home-manager;
    overlays = import ./overlays {inherit inputs outputs;};
    nixosConfigurations = {
      workstation = lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          vars = import ./hosts/workstation/vars.nix;
        };
        modules = [
          ./hosts/workstation
        ];
      };
      y520 = lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          vars = import ./hosts/y520/vars.nix;
        };
        modules = [
          ./hosts/y520
        ];
      };
      nuc8i3beh = lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          vars = import ./hosts/nuc8i3beh/vars.nix;
        };
        modules = [
          ./hosts/nuc8i3beh
        ];
      };
      pi3b = lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          vars = import ./hosts/pi3b/vars.nix;
        };
        modules = [
          ./hosts/pi3b
        ];
      };
    };

    # home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "javier@workstation" = lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          vars = import ./hosts/workstation/vars.nix;
        };
        modules = [
          ./home-manager/workstation.nix
        ];
      };
      "javier@y520" = lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          vars = import ./hosts/y520/vars.nix;
        };
        modules = [
          ./home-manager/y520.nix
        ];
      };
      "javier@nuc8i3beh" = lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          vars = import ./hosts/nuc8i3beh/vars.nix;
        };
        modules = [
          ./home-manager/nuc8i3beh.nix
        ];
      };
      "vagrant@vagrantbox" = lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          vars = import ./hosts/y520/vars.nix;
        };
        modules = [
          ./home-manager/vagrantbox.nix
        ];
      };
      "javier@pi3b" = lib.homeManagerConfiguration {
        pkgs = pkgsFor.aarch64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          vars = import ./hosts/pi3b/vars.nix;
        };
        modules = [
          ./home-manager/pi3b.nix
        ];
      };
    };
  };
}
