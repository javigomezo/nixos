{
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins.oil = {
      enable = false;
      lazyLoad.settings.cmd = "Oil";
    };
  };
}
