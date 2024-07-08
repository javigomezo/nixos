{
  programs.nixvim.plugins.flash = {
    enable = true;
    #search.mode = "fuzzy";
    settings = {
      jump.autojump = true;
      label = {
        uppercase = false;
        rainbow = {
          enabled = false;
          shade = 5;
        };
      };
    };
  };
  programs.nixvim.keymaps = [
    {
      mode = ["n" "x" "o"];
      key = "s";
      action = "<cmd>lua require('flash').jump()<cr>";
      options = {
        desc = "Flash";
      };
    }
  ];
}
