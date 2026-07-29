{
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins.noice = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
    };
  };
}
