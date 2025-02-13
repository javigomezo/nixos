{
  programs.nixvim.plugins.bufferline = {
    enable = true;
    lazyLoad.settings.event = "BufEnter";
  };
  programs.nixvim.plugins.lualine = {
    enable = true;
    lazyLoad.settings.event = "DeferredUIEnter";
    settings = {
      icons_enabled = true;
      options = {
        component_separators = "";
        section_separators = {
          left = "";
          right = "";
        };
      };
      sections = {
        "lualine_a" = [
          {
            __unkeyed = "mode";
            separator.left = "";
            right_padding = 2;
            left_padding = 2;
          }
        ];
        "lualine_b" = [
          {
            __unkeyed = "branch";
          }
        ];
        "lualine_c" = [
          {
            __unkeyed = "%=";
          }
          {
            __unkeyed = "filename";
            separator = {
              left = "";
              right = "";
            };
          }
        ];
        "lualine_x" = [{}];
        "lualine_y" = [{__unkeyed = "filetype";} {__unkeyed = "progress";}];
        "lualine_z" = [
          {
            __unkeyed = "location";
            separator.right = "";
            padding.left = 2;
          }
        ];
      };
      inactive_sections = {
        lualine_a = [];
        lualine_b = [];
        lualine_c = ["filename"];
        lualine_x = [];
        lualine_y = [];
        lualine_z = ["location"];
      };
    };
  };
}
