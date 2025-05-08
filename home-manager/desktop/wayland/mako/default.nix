{
  services.mako = {
    enable = true;
    settings = {
      icons = true;
      default-timeout = 5000;
      anchor = "top-right";
      max-visible = 5;
      sort = "-time";
      layer = "overlay"; # Above fullscreen
      border-radius = 8;
      border-size = 2;
      margin = 10;
      padding = 10;
      width = 350;
    };
    # Appearance
    #font = "Comic Code Ligatures 11, Inter Medium 11";
    #borderRadius = 8;
    # extraConfig = ''
    #   [urgency=high]
    #   border-color=#bf616a
    #   ignore-timeout=1
    # '';
  };
}
