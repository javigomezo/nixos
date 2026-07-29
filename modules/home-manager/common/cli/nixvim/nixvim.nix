{inputs, ...}: {
  flake.modules.homeManager.nixvim = {
    imports = [
      inputs.nixvim.homeModules.nixvim
    ];
    programs.neovim = {
      vimAlias = true;
      defaultEditor = true;
    };
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      opts = {
        number = true;
        relativenumber = true;
        shiftwidth = 2;
        laststatus = 2;
        showtabline = 2;
        termguicolors = true;
        conceallevel = 1;
      };
      nixpkgs = {
        source = inputs.nixpkgs;
        config = {
          allowUnfree = true;
        };
      };
      extraConfigVim = ''
        set undofile
      '';
      autoCmd = [
        {
          event = "TextYankPost";
          group = "YankHighlight";
          callback = {
            __raw = "function() vim.highlight.on_yank() end";
          };
        }
      ];
      autoGroups = {
        "YankHighlight" = {
          clear = true;
        };
      };
    };
  };
}
