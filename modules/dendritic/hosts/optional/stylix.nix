{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.stylix = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];
    stylix = {
      enable = true;
      image = self + "/modules/dendritic/wallpapers/${config.my.vars.wallpaper}";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    };
  };
}
