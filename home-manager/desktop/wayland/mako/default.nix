{
  services.mako = {
    enable = true;
    icons = true;
    defaultTimeout = 5000;
    maxVisible = 5;
    sort = "-time";
    layer = "overlay"; # Above fullscreen
    anchor = "top-right";
    # Appearance
    #font = "Comic Code Ligatures 11, Inter Medium 11";
    width = 350;
    padding = "10";
    margin = "10";
    borderSize = 2;
    borderRadius = 8;
    extraConfig = ''
      [urgency=high]
      border-color=#bf616a
      ignore-timeout=1
    '';
  };
}
