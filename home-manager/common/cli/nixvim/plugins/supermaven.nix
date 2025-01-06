{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "supermaven-nvim.nvim";
        version = "25-01";
        src = pkgs.fetchFromGitHub {
          owner = "supermaven-inc";
          repo = "supermaven-nvim";
          rev = "07d20fce48a5629686aefb0a7cd4b25e33947d50";
          hash = "";
        };
      })
    ];
    extraConfigLua = ''
      require("supermaven-nvim").setup({})
    '';
  };
}
