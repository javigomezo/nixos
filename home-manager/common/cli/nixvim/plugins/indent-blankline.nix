{
  programs.nixvim.plugins.indent-blankline = {
    enable = true;
    lazyLoad.settings.event = ["BufReadPost" "BufWritePost" "BufNewFile"];
    settings = {
      indent = {
        char = "│";
        tab_char = "│";
      };
      scope = {
        enabled = true;
        show_start = true;
      };
      exclude = {
        buftypes = ["terminal" "nofile"];
        filetypes = [
          "help"
          "alpha"
          "dashboard"
          "neo-tree"
          "Trouble"
          "trouble"
          "lazy"
          "mason"
          "notify"
          "toggleterm"
          "lazyterm"
        ];
      };
    };
  };
}
