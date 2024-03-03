{
  imports = [
    ./cli
    ./git.nix
    ./neovim.nix
    ./nixpkgs.nix
  ];

  home = {
    username = "javier";
    homeDirectory = "/home/javier";
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
