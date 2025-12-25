{inputs, ...}: {
  custom-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
    mine = import inputs.nixpkgs-mine {
      system = final.stdenv.hostPlatform.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
  };
}
