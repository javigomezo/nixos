{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      size = 50000;
      extended = true;
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    completionInit = ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} r:|=* l:|=* r:|=*'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      autoload -U compinit
      compinit
    '';
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      cd = "z";
      df = "duf";
      ls = "eza --color=always --icons --group-directories-first";
      l = "ls";
      la = "ls -a";
      li = "ls -a | grep -i";
      ll = "ls -l";
      lla = "ls -lah";
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
    dircolors = {
      enable = true;
      enableZshIntegration = true;
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
