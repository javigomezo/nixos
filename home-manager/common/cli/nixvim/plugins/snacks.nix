{
  programs.nixvim.plugins.snacks = {
    enable = true;
    settings = {
      dashboard = {
        enable = true;
        sections = [
          {section = "header";}
          {
            icon = "  ";
            title = "Keymaps";
            section = "keys";
            padding = 1;
            indent = 2;
          }
          {
            icon = " ";
            title = "Recent Files";
            section = "recent_files";
            padding = 1;
            indent = 2;
          }
          {
            icon = "  ";
            title = "Projects";
            section = "projects";
            padding = 1;
            indent = 2;
          }
        ];
      };
      notifier.enable = true;
      notify.enable = true;
      quickfile.enable = true;
    };
  };
}
