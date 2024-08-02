{
  imports = [
    ./adguard_config.nix
  ];
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
  };
}
