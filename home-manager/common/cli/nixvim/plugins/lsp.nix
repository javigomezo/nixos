{
  programs.nixvim.plugins.lsp = {
    enable = true;
    inlayHints = true;
    lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
    servers = {
      lua_ls.enable = true;
      pyright.enable = true;
      nixd.enable = true;
    };
  };
}
