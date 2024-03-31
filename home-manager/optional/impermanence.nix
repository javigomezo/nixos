{
  home.persistence."/persist/home/javier" = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      ".ssh"
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];
    files = [
      ".zsh_history"
    ];
    allowOther = true;
  };
}
