{
  imports = [
    ./ts-context-commentstring.nix
  ];
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      indent = true;
      folding = false;
      nixvimInjections = true;
    };
    treesitter-context = {
      enable = true;
    };
  };
}
