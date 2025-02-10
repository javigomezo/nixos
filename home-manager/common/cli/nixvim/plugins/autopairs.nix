{
  programs.nixvim.plugins.nvim-autopairs = {
    enable = true;
    lazyLoad.settings.event = "InsertEnter";
  };
}
