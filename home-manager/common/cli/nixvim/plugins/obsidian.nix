{
  programs.nixvim.plugins.obsidian = {
    enable = false;
    lazyLoad.settings.ft = "markdown";
    settings = {
      workspaces = [
        {
          name = "personal";
          path = "~/obsidian/";
        }
      ];
    };
  };
}
