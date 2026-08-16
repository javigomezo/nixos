{
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins.telescope = {
      enable = true;
      # colorscheme.enable_preview = true;
      lazyLoad.settings.cmd = "Telescope";
      extensions = {
        fzf-native.enable = true;
      };
      highlightTheme = "nord";
      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>b" = "buffers";
        "<leader>fh" = "help_tags";
        "<leader>fd" = "diagnostics";
        "<leader>fr" = "oldfiles";
      };
      settings = {
        pickers = {
          find_files.hidden = true;
        };
        defaults = {
          mappings = {
            i = {
              "<esc>" = {
                __raw = "require('telescope.actions').close";
              };
            };
          };
          file_ignore_patterns = [
            "^.git/"
            "^__pycache__/"
          ];
          set_env.COLORTERM = "truecolor";
        };
      };
    };
  };
}
