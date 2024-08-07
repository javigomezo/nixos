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
    colorschemes.nord.enable = true;
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
    globals.mapleader = " ";
    extraConfigVim = ''
      set undofile
    '';
  };
}
