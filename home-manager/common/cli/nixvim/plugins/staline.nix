{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "staline.nvim";
        version = "24-06";
        src = pkgs.fetchFromGitHub {
          owner = "tamton-aquib";
          repo = "staline.nvim";
          rev = "d337bc9b343df3328921ef4c3f8ff604102d0201";
          hash = "sha256-HkuVio/F8HOb6k9N8LkYdQ1vheuyjrqP25RforoWZSk=";
        };
      })
    ];
    extraConfigLua = ''
        require("stabline").setup(
          {
            bg = "#434c5e",
          }
        )
        require("staline").setup({
        sections = {
            left = {
                ' ', 'right_sep', '-mode', 'left_sep', ' ',
                'right_sep', '-file_name', 'left_sep', ' ',
                'right_sep', '-branch', 'left_sep', ' ',
            },
            mid  = {'lsp'},
            right= {
                'right_sep', '-cool_symbol', 'left_sep', ' ',
                'right_sep', '- ', '-lsp_name', '- ', 'left_sep', ' ',
                'right_sep', '-line_column', 'left_sep', ' ',
            }
        },
        defaults={
            -- fg = "#986fec",
            cool_symbol = "  ",
            left_separator = "",
            right_separator = "",
            true_colors = true,
            line_column = "[%l:%c] %p%% "
            -- font_active = "bold"
        }
      })
    '';
  };
}
