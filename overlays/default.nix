{inputs, ...}: {
  custom-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
    mine = import inputs.nixpkgs-mine {
      system = final.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
  };
}
