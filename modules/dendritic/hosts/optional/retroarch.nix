{
  flake.nixosModules.retroarch = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      (retroarch.withCores (cores:
        with cores; [
          beetle-psx-hw
          mgba
        ]))
    ];
  };
}
