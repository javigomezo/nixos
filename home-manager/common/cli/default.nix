{pkgs, ...}: {
  imports = [
    ./starship
    ./tmux
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
    ripgrep
    stow
    tmux
    unzip
    vim
    zip
  ];
}
