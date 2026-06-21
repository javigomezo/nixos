{
  flake.modules.homeManager.nixvim = {
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
        folding.enable = false;
        nixvimInjections = true;
      };
      treesitter-context = {
        enable = true;
      };
    };
    programs.nixvim.plugins.ts-context-commentstring = {
      enable = false;
      disableAutoInitialization = false;
    };
  };
}
