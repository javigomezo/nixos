{
  programs.nixvim.plugins = {
    web-devicons = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
    };
    mini = {
      enable = true;
      # lazyLoad.settings.event = "DeferredUIEnter";
      modules = {
        indentscope = {
          symbol = "│";
          options = {try_as_border = true;};
        };
        comment = {
          options = {
            customCommentString = ''
              <cmd>lua require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring<cr>
            '';
          };
        };
      };
    };
  };
}
