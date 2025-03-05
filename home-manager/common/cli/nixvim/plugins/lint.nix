{pkgs, ...}: {
  home.packages = with pkgs; [
    nodePackages.jsonlint
    python311Packages.flake8
    hadolint
    tflint
  ];

  programs.nixvim.plugins.lint = {
    enable = true;
    lazyLoad.settings.event = ["DeferredUIEnter"];
    lintersByFt = {
      json = ["jsonlint"];
      dockerfile = ["hadolint"];
      python = ["flake8"];
      nix = ["nix"];
      terraform = ["tflint"];
    };
    # autoCmd.event = ["BufEnter" "BufWritePost" "InsertLeave"];
  };
}
