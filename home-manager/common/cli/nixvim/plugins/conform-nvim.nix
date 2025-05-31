{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
  ];

  programs.ruff = {
    enable = true;
    settings = {
      line-length = 88;
      lint.preview = true;
      format.preview = true;
    };
  };
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
        #python = ["isort" "black"];
        python = ["ruff_fix" "ruff_organize_imports"];
        javascript = [["prettierd" "prettier"]];
        "_" = ["trim_whitespace"];
      };
    };
  };
}
