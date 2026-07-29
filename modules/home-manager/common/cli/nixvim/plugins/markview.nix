{
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins.markview = {
      enable = false;
      lazyLoad.settings.ft = "markdown";
    };
  };
}
