{inputs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./keymaps.nix
    ./plugins
  ];
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      laststatus = 2;
      showtabline = 2;
      termguicolors = true;
      conceallevel = 1;
    };
    nixpkgs.config = {
      allowUnfree = true;
    };
    globals.mapleader = " ";
    extraConfigVim = ''
      set undofile
    '';
  };
}
