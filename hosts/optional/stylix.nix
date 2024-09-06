{
  inputs,
  vars,
  pkgs,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  config = {
    stylix = {
      enable = true;
      image = ./wallpapers/${vars.wallpaper};
      base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    };
  };
}
