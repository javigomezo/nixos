{
  lib,
  config,
  inputs,
  pkgs,
  vars,
  ...
}: {
  options.my.stylix = {
    enable = lib.mkOption {
      description = "Enables stylix";
      type = lib.types.bool;
      default = true;
    };
    desktop = lib.mkOption {
      description = "Enables desktop configuration";
      type = lib.types.bool;
      default = false;
    };
  };
  config = {
    stylix = {
      enable = config.my.stylix.enable;
      image = ./wallpapers/${vars.wallpaper};
      base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
      cursor = lib.mkIf config.my.stylix.desktop {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };
      fonts = lib.mkIf config.my.stylix.desktop {
        monospace = {
          name = "Comic Code Ligatures";
          package = inputs.private-fonts.packages.x86_64-linux.ComicCodeLigatures;
        };
        emoji = {
          name = "Noto Color Emoji";
          package = pkgs.noto-fonts-color-emoji;
        };
        sizes = {
          terminal = 12;
          desktop = 12;
          popups = 12;
        };
      };
      opacity = lib.mkIf config.my.stylix.desktop {
        terminal = 0.82;
      };

      targets = {
        firefox = {
          profileNames = ["deault"];
          colorTheme.enable = true;
        };
        hyprlock.enable = false;
        nixvim.transparentBackground = {
          main = true;
          signColumn = true;
        };
        rofi.enable = true;
        waybar.enable = false;
      };
      polarity = "dark";
    };
  };
}
