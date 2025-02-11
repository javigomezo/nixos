{
  programs.nixvim.plugins.comment = {
    enable = true;
    lazyLoad.settings.keys = ["<leader>c"];
    settings.toggler = {
      line = "<leader>c";
    };
  };
}
