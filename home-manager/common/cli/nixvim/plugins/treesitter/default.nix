{
  imports = [
    ./ts-context-commentstring.nix
  ];
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      settings.indent.enable = true;
      folding = false;
      nixvimInjections = true;
    };
    treesitter-context = {
      enable = true;
    };
  };
}
