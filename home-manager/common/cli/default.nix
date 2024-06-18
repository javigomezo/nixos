{pkgs, ...}: {
  imports = [
    ./starship
    #./nixvim
    ./tmux
    ./zsh
  ];

  home.packages = with pkgs; [
    compsize
    dig
    duf
    eza
    gcc
    gdu
    git
    gnumake
    nitch
    nixd
    htop
    outils
    (python3.withPackages (ps: with ps; [requests]))
    pyright
    ripgrep
    stow
    tmux
    unzip
    vim
    zip
  ];
}
