{
  programs.nixvim.plugins.lsp = {
    enable = true;
    inlayHints = true;
    lazyLoad.settings = {
      before.__raw = ''
        function()
          require("lz.n").trigger_load("blink.cmp")
        end
      '';
      lazyLoad.settings.event = ["BufReadPre" "BufNewFile" "BufWritePost"];
    };
    servers = {
      lua_ls.enable = true;
      pyright.enable = true;
      nixd.enable = true;
    };
  };
}
