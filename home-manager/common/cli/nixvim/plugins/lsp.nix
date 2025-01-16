{
  programs.nixvim.plugins.lsp = {
    enable = true;
    lazyLoad.settings.event = "BufEnter";
    servers = {
      lua_ls.enable = true;
      pyright.enable = true;
      nixd.enable = true;
    };
  };
}
