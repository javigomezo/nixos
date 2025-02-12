{
  programs.nixvim.plugins.notify = {
    enable = true;
    lazyLoad.settings.event = "DeferredUIEnter";
    settings = {
      fps = 60;
      render = "minimal";
      background_colour = "#2e3440";
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
