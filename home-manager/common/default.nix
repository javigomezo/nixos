{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
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

  nixpkgs = {
    overlays = [
      outputs.overlays.custom-packages
      inputs.nur.overlays.default
    ];
    config.allowUnfree = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
