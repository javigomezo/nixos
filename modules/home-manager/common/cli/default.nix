{
  self,
  inputs,
  ...
}: {
  flake.modules.homeManager.cli = {pkgs, ...}: {
    imports = [
      inputs.stylix.homeModules.stylix
      self.modules.homeManager.git
      self.modules.homeManager.starship
      self.modules.homeManager.nixvim
      self.modules.homeManager.tmux
      self.modules.homeManager.zsh
      self.modules.homeManager.stylix
      self.modules.homeManager.vars
    ];

    nixpkgs = {
      config.allowUnfree = true;
      overlays = [
        self.overlays.custom-packages
        inputs.nur.overlays.default
      ];
    };

    programs.home-manager.enable = true;
    home = {
      username = "javier";
      homeDirectory = "/home/javier";
      packages = with pkgs; [
        compsize
        dig
        duf
        eza
        gcc
        gdu
        git
        gnumake
        htop
        nitch
        nixd
        outils
        (python3.withPackages (ps: with ps; [requests]))
        pyright
        restic
        ripgrep
        stow
        tmux
        unzip
        zip
      ];
    };
    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}
