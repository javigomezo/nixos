{
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins.comment = {
      enable = true;
      settings.toggler = {
        line = "<leader>c";
      };
    };
  };
}
