{
  programs.nixvim.plugins.noice = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings.event = "DeferredUIEnter";
    };
  };
}
