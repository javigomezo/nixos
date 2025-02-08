{
  programs.nixvim.plugins.notify = {
    enable = true;
    settings = {
      fps = 60;
      render = "minimal";
    };
  };
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>un";
      action = ''
        <cmd>lua require("notify").dismiss({ silent = true, pending = true })<cr>
      '';
      options = {
        desc = "Dismiss All Notifications";
      };
    }
  ];
}
