{pkgs, ...}: {
  home.packages = with pkgs; [
    nodePackages.jsonlint
    hadolint
    tflint
  ];

  programs.nixvim.plugins.lint = {
    enable = true;
    # lazyLoad.settings.event = ["DeferredUIEnter"];
    lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
    lintersByFt = {
      json = ["jsonlint"];
      dockerfile = ["hadolint"];
      python = ["ruff"];
      nix = ["nix"];
    };
    # autoCmd.event = ["BufEnter" "BufWritePost" "InsertLeave"];
  };
}
