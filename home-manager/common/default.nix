{inputs, ...}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
    ./cli
    ./git.nix
    ./neovim.nix
    ./stylix
  ];

  home = {
    username = "javier";
    homeDirectory = "/home/javier";
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
