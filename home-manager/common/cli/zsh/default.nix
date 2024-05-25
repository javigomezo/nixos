{
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
      cd = "z";
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
      if [[ $- == *i* ]]; then
        clear;nitch;
      fi
    '';
  };

  programs = {
    bat = {
      enable = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
