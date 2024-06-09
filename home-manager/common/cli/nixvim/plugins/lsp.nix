{
  programs.nixvim.plugins.lsp = {
    enable = true;
    servers = {
      lua-ls.enable = true;
      pyright.enable = true;
      nixd.enable = true;
    };
  };
}
