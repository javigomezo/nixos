{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "supermaven-nvim.nvim";
        version = "24-06";
        src = pkgs.fetchFromGitHub {
          owner = "supermaven-inc";
          repo = "supermaven-nvim";
          rev = "ef3bd1a6b6f722857f2f88d929dd4ac875655611";
          hash = "sha256-mlVo/ZKDZUjOfXwaLhpi45B4zxtnwa40GEIaa1E+sy0=";
        };
      })
    ];
    extraConfigLua = ''
      require("supermaven-nvim").setup({})
    '';
  };
}
