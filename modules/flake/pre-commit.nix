{
  self,
  inputs,
  ...
}: {
  perSystem = {system, ...}: {
    checks.pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
      src = self;
      hooks = {
        alejandra.enable = true;
        deadnix.enable = true;
      };
    };
  };
}
