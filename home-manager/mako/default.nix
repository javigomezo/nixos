{ lib, config, pkgs, ... }:

{
  services.mako = {
    enable = true;
    maxVisible = 5;
    sort = "-time";
    layer = "overlay"; # Above fullscreen
    anchor = "top-right";
    # Appearance
    font = "Comic Code Ligatures 11, Inter Medium 11";
    width = 350;
    padding = "10";
    margin = "10";
    borderSize = 2;
    borderRadius = 8; 
    backgroundColor = "#3b4252";
    textColor = "#eceff4";
    borderColor = "#a3be8c";
    extraConfig = ''
      [urgency=high]
      border-color=#bf616a
      ignore-timeout=1
    '';
  };
}
