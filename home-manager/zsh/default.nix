{ lib, config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    initExtra = builtins.readFile ./config.sh;
  };
}
