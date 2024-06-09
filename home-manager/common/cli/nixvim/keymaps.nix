{
  programs.nixvim = {
    globals.mapleader = " ";
    keymaps = [
      {
        mode = ["n"];
        action = ":bnext<CR>";
        key = "<S-l>";
        options = {
          silent = true;
        };
      }
      {
        mode = ["n"];
        action = ":bprevious<CR>";
        key = "<S-h>";
        options = {
          silent = true;
        };
      }
    ];
  };
}
