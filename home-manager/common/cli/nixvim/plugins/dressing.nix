{
  programs.nixvim.plugins.dressing = {
    enable = true;
    lazyLoad.settings.event = "DeferredUIEnter";
    settings = {
      enabled = true;
      input = {
        enabled = true;
        default_prompt = "Input: ";
        insert_only = true;
        start_in_insert = true;
        border = "rounded";
        relative = "cursor";
        prefer_width = 40;
        win_options = {
          winblend = 10;
          wrap = false;
          list = true;
          listchars = "precedes:...,extends:...";
          sidescrolloff = 0;
        };
      };
      select = {
        enabled = true;
        backend = [
          "telescope"
          "fzf_lua"
          "fzf"
          "builtin"
          "nui"
        ];
        trim_prompt = true;
      };
    };
  };
}
