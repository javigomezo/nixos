{
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins.windsurf-vim = {
      enable = false;
    };
  };
}
