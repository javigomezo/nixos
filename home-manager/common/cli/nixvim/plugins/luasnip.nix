{pkgs, ...}: {
  programs.nixvim.plugins.luasnip = {
    enable = true;
    lazyLoad.settings.event = "InsertEnter";
    settings = {
      enable_autosnippets = true;
    };
    fromVscode = [
      {
        lazyLoad = true;
        paths = "${pkgs.vimPlugins.friendly-snippets}";
      }
    ];
  };
}
