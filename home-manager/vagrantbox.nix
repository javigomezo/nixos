{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./common
  ];

  fonts.fontconfig.enable = true;
  xdg.enable = false;
  xsession.enable = false;

  home = {
    username = lib.mkForce "vagrant";
    homeDirectory = lib.mkForce "/home/vagrant";
  };

  home.packages = with pkgs; [
    kubectl
  ];

  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";
}
