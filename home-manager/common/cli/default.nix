{pkgs, ...}: {
  imports = [
    ./starship
    ./zsh
  ];

  home.packages = with pkgs; [
    duf
    eza
    git
    nitch
    nixd
    htop
    (python3.withPackages (ps: with ps; [requests]))
    ripgrep
    stow
    tmux
    vim
  ];
}
