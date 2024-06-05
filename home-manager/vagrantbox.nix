{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./common
  ];

  fonts.fontconfig.enable = true;
  xdg.enable = false;
  xsession.enable = false;

  home = {
    username = lib.mkForce "vagrant";
    homeDirectory = lib.mkForce "/home/vagrant";
  };

  home.packages = with pkgs; [
    alejandra
    kubectl
    k9s
    sshuttle
  ];

  programs.zsh.history.path = lib.mkForce "/vagrant/projects/.zsh_history";
  programs.zsh.history.size = 50000;
  programs.git = {
    enable = true;
    userName = lib.mkForce "Javier Gomez Ortiz";
    userEmail = lib.mkForce "javier.gomez@eviden.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  home.sessionVariables = {
    KUBECONFIG = "$(\ls -d ~/.kube/* | grep config- | tr '\n' ':')";
  };

  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";
}
