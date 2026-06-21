{
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins.alpha = {
      enable = false;
      theme = "dashboard";
    };
  };
}
