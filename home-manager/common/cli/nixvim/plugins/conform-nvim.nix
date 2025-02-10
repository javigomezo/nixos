{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    black
    isort
  ];
  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    lazyLoad.settings = {
      cmd = ["ConformInfo"];
      event = ["BufWrite"];
    };
    settings = {
      format_on_save = {
        timeoutMs = 500;
        lspFallback = true;
      };
      formatters_by_ft = {
        lua = ["stylua"];
        nix = ["alejandra"];
        python = ["isort" "black"];
        javascript = [["prettierd" "prettier"]];
        "_" = ["trim_whitespace"];
      };
    };
  };
}
