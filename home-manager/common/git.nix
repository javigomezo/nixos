{
  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      user = {
        name = "javigomezo";
        email = "mail@javigomezo.com";
      };
      init.defaultBranch = "main";
    };
  };
}
