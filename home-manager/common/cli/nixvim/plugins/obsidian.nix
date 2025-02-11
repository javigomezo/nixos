{
  programs.nixvim.plugins.obsidian = {
    enable = true;
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
