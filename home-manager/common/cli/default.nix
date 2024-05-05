{pkgs, ...}: {
  imports = [
    ./starship
    ./zsh
  ];

  home.packages = with pkgs; [
    compsize
    dig
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
    xarchiver
    vim
    zip
  ];
}
