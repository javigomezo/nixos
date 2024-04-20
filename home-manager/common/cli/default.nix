{pkgs, ...}: {
  imports = [
    ./starship
    ./zsh
  ];

  home.packages = with pkgs; [
    duf
    eza
    gdu
    git
    gnumake
    nitch
    nixd
    htop
    outils
    (python3.withPackages (ps: with ps; [requests]))
    qmk
    ripgrep
    stow
    tmux
    unzip
    vim
    zip
  ];
}
