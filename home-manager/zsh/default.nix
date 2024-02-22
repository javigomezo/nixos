{ lib, config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      df = "duf";
      ls = "eza --color=always --icons --group-directories-first";
      la = "ls -a";
      li = "ls -a | grep -i";
      ll = "ls -lh";
      lla = "ls -lah";
      l = "ls -l";
      #cat = "bat";
      k = "kubectl";
      kubechange = "kubectl config use-context ";
      kubecontext = "kubectl config get-contexts";
      nvidia-smi = "watch -n 1 nvidia-smi";
    };
    initExtra = ''
      if [[ $- == *i* ]] && command -v nitch > /dev/null; then
        clear;nitch;
      fi
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
