{
  programs.nixvim.plugins = {
    web-devicons = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
    };
    mini = {
      enable = true;
      # lazyLoad.settings.event = "DeferredUIEnter";
      modules = {
        indentscope = {
          symbol = "│";
          options = {try_as_border = true;};
        };
      };
    };
  };
}
