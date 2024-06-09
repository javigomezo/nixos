{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    black
    isort
  ];
  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    formatOnSave = {
      timeoutMs = 500;
      lspFallback = true;
    };
    formattersByFt = {
      lua = ["stylua"];
      nix = ["alejandra"];
      python = ["isort" "black"];
      javascript = [["prettierd" "prettier"]];
      "_" = ["trim_whitespace"];
    };
  };
}
