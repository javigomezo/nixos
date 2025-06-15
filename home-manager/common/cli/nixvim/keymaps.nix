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
        action = "<cmd>nohlsearch<CR>";
        key = "<Esc>";
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
        mode = ["n"];
        action = "<C-u>zz";
        key = "<C-u>";
      }
      {
        mode = ["n"];
        action = "<C-d>zz";
        key = "<C-d>";
      }
      {
        mode = ["n"];
        action = "Nzzzv";
        key = "N";
      }
      {
        mode = ["n"];
        action = "nzzzv";
        key = "n";
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
