{
  pkgs,
  # self,
  ...
}: {
  imports = [
    ./starship
    # ./nixvim
    ./tmux
    ./zsh
    # self.modules.homeManager.nixvim
  ];

  #  modules = [
  #    {imports = [self.modules.homeManager.nixvim];}
  #  ];

  home.packages = with pkgs; [
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
}
