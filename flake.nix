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

    hyprland = {
      url = "github:hyprwm/Hyprland";
      # build with your own instance of nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper.url = "github:hyprwm/hyprpaper";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, hyprland, ... }: {
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.users.javier = import ./home.nix;
          }
        ];
      };
    };
    #homeConfigurations."javier@nixos" = home-manager.lib.homeManagerConfiguration {
    #  pkgs = nixpkgs.legacyPackages.x86_64-linux;
    #  modules = [
    #    hyprland.homeManagerModules.default
    #    {
    #      wayland.windowManager.hyprland = 
    #      {
    #        enable = true;
    #        xwayland = {
    #          enable = true;
    #          hidpi = false;
    #        };
    #        systemdIntegration = true;
    #        nvidiaPatches = true;
    #      };
    #    }
    #  ];
    #};
  };
}
