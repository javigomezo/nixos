{
  flake.modules.homeManager.nixvim = {
    programs.nixvim.plugins = {
      blink-cmp = {
        enable = true;
        lazyLoad.settings.event = "VimEnter";
        settings = {
          appearance = {
            kind_icons = {
              Class = "󱡠";
              Color = "󰏘";
              Constant = "󰏿";
              Constructor = "󰒓";
              Copilot = "";
              Enum = "󰦨";
              EnumMember = "󰦨";
              Event = "󱐋";
              Field = "󰜢";
              File = "󰈔";
              Folder = "󰉋";
              Function = "󰊕";
              Interface = "󱡠";
              Keyword = "󰻾";
              Method = "󰊕";
              Module = "󰅩";
              Operator = "󰪚";
              Property = "󰖷";
              Reference = "󰬲";
              Snippet = "󱄽";
              Struct = "󱡠";
              Text = "󰉿";
              TypeParameter = "󰬛";
              Unit = "󰪚";
              Value = "󰦨";
              Variable = "󰆦";
            };
          };
          snippets.preset = "luasnip";
          completion = {
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
            };
          };
          sources = {
            default = [
              "buffer"
              # "git"
              # "lazydev"
              "lsp"
              "path"
              # "ripgrep"
              "snippets"
            ];
            providers = {
              lsp = {
                name = "LSP";
                module = "blink.cmp.sources.lsp";

                fallbacks = [
                  "buffer"
                ];
              };
              path = {
                name = "Path";
                module = "blink.cmp.sources.path";
                score_offset = 3;

                fallbacks = [
                  "buffer"
                ];

                opts = {
                  label_trailing_slash = true;
                  show_hidden_files_by_default = false;
                  trailing_slash = false;
                };
              };

              buffer = {
                name = "Buffer";
                module = "blink.cmp.sources.buffer";
              };
            };
          };
        };
      };
    };
  };
}
