{
  imports = [
    ./common
  ];

  my.stylix.desktop = false;
  xdg.enable = true;
  services.podman.autoUpdate = {
    enable = true;
    onCalendar = "5 55 * * *";
  };

  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
