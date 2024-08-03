{
  imports = [
    ./configuration.nix
  ];
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
  };
}
