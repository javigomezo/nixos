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
      image = ../../home-manager/common/stylix/wallpapers/${vars.wallpaper};
      base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    };
  };
}
