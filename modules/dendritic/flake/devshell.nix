{inputs, ...}: {
  perSystem = {
    system,
    config,
    ...
  }: {
    devShells.default = inputs.nixpkgs.legacyPackages.${system}.mkShell {
      inherit (config.checks.pre-commit-check) shellHook;
      buildInputs = config.checks.pre-commit-check.enabledPackages;
    };
  };
}
