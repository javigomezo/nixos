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
      {
        mode = ["v"];
        action = ":m '>+1<CR>gv=gv";
        key = "J";
        options = {
          silent = true;
        };
      }
      {
        mode = ["v"];
        action = ":m '<-2<CR>gv=gv";
        key = "K";
        options = {
          silent = true;
        };
      }
    ];
  };
}
