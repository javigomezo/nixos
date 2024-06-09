{pkgs, ...}: {
  programs.nixvim.plugins.luasnip = {
    enable = true;
    extraConfig = {
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
