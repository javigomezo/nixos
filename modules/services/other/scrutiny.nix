{
  flake.nixosModules.scrutiny = {
    services.scrutiny = {
      enable = true;
    };
  };
}
