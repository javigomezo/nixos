{self, ...}: {
  flake.modules.homeManager.vagrantConfig = {
    lib,
    pkgs,
    ...
  }: {
    imports = [
      self.modules.homeManager.cli
    ];

    fonts.fontconfig.enable = lib.mkForce false;

    home = {
      username = lib.mkForce "vagrant";
      homeDirectory = lib.mkForce "/home/vagrant";
    };

    home.packages = with pkgs; [
      apacheHttpd
      kubectl
      kubernetes-helm
      k9s
      # sshuttle
      google-cloud-sdk
    ];

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = lib.mkForce "Javier Gomez Ortiz";
          email = lib.mkForce "javier.gomez@eviden.com";
        };
        init.defaultBranch = "main";
      };
    };

    home.sessionVariables = {
      KUBECONFIG = "$(\ls -d /vagrant/projects/.kube/* | grep config- | tr '\n' ':')";
    };

    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "24.11";
  };
}
