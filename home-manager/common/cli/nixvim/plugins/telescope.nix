{
  programs.nixvim.plugins.telescope = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings.cmd = "Telescope";
    };
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
      "<leader>r" = "oldfiles";
    };
    settings = {
      defaults = {
        mappings = {
          i = {
            "<esc>" = {
              __raw = ''
                function(...)
                  return require("telescope.actions").close(...)
                end'';
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

  programs.nixvim.extraConfigLua = ''
    local telescope = require('telescope').setup{
      pickers = {
        find_files = {
          hidden = true
        },
        colorscheme = {
          enable_preview = true
        }
      }
    }
  '';
}
