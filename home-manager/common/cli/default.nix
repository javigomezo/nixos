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
    nitch
    nixd
    htop
    (python3.withPackages (ps: with ps; [requests]))
    qmk
    ripgrep
    stow
    tmux
    vim
  ];
}
