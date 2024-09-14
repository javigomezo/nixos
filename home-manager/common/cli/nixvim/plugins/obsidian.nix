{
  programs.nixvim.plugins.obsidian = {
    enable = true;
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
