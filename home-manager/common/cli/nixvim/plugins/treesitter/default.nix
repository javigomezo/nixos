{
  imports = [
    ./ts-context-commentstring.nix
  ];
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      lazyLoad.settings.event = [
        "BufNewFile"
        "BufReadPost"
        "BufWritePost"
        "DeferredUIEnter"
      ];
      settings = {
        indent.enable = true;
        highlight.enable = true;
      };
      folding = false;
      nixvimInjections = true;
    };
    treesitter-context = {
      enable = true;
    };
  };
}
