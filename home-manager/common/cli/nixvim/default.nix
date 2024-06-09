{inputs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./keymaps.nix
    ./plugins
  ];
  programs.nixvim = {
    enable = true;
    vimAlias = true;
    colorschemes.nord.enable = true;
    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
    globals.mapleader = " ";
  };
}
