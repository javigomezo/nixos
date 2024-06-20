{
  programs.nixvim.plugins.mini = {
    enable = true;
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
}
