{
  programs.nixvim.plugins.obsidian = {
    enable = true;
    settings = {
      workspaces = [
        {
          name = "personal";
          path = "~/Documents/Obsidian Vault";
        }
      ];
    };
  };
}
