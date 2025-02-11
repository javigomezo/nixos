{
  programs.nixvim.plugins = {
    # cmp-nvim-lsp.enable = true;
    # cmp-buffer.enable = true;
    # cmp-path.enable = true;
    # cmp_luasnip.enable = true;
    # cmp-cmdline.enable = false;
    cmp = {
      enable = false;
      #autoEnableSources = true;
      settings = {
        experimental = {
          ghost_text = true;
        };
        mapping = {
          __raw = ''
            cmp.mapping.preset.insert({
                ['<C-j>'] = cmp.mapping.select_next_item(),
                ['<C-k>'] = cmp.mapping.select_prev_item(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<S-CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
            })
          '';
        };
        snippet.expand = ''
          function(args)
              require('luasnip').lsp_expand(args.body)
          end
        '';
        sources = [
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "path";}
          {
            name = "buffer";
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
          }
        ];
        performance = {
          debounce = 60;
          fetching_timeout = 200;
          max_view_entries = 30;
        };
        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
          };
          documentation = {
            border = "rounded";
          };
        };
        formatting = {
          fields = ["kind" "abbr" "menu"];
          expandable_indicator = true;
          format = ''
            function(_, item)
              local icons = {
                Namespace = "󰌗",
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰆧",
                Constructor = "",
                Field = "󰜢",
                Variable = "󰀫",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈚",
                Reference = "󰈇",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "󰙅",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "󰊄",
                Table = "",
                Object = "󰅩",
                Tag = "",
                Array = "[]",
                Boolean = "",
                Number = "",
                Null = "󰟢",
                String = "󰉿",
                Calendar = "",
                Watch = "󰥔",
                Package = "",
                Copilot = "",
                Codeium = "",
              }

              local icon = icons[item.kind] or ""
              item.kind = string.format("%s %s", icon, item.kind or "")
              return item
            end
          '';
        };
      };
    };
  };
}
