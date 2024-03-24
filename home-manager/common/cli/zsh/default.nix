{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  packageNames = map (p: p.pname or p.name or null) config.home.packages;
  hasPackage = name: lib.any (x: x == name) packageNames;
  hasDuf = hasPackage "duf";
  hasEza = hasPackage "eza";
  hasKubectl = hasPackage "kubectl";
  hasNitch = hasPackage "nitch";
in {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    completionInit = "
      zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
      autoload -U compinit
      autoload -Uz zcalc
    ";
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      df = mkIf hasDuf "duf";
      ls = mkIf hasEza "eza --color=always --icons --group-directories-first";
      la = "ls -a";
      li = "ls -a | grep -i";
      ll = "ls -lh";
      lla = "ls -lah";
      l = "ls -l";
      #cat = "bat";
      k = mkIf hasKubectl "kubectl";
      kubechange = "kubectl config use-context ";
      kubecontext = "kubectl config get-contexts";
      nvidia-smi = "watch -n 1 nvidia-smi";
    };
    initExtra = mkIf hasNitch ''
      if [[ $- == *i* ]]; then
        clear;nitch;
      fi
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
