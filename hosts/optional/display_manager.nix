{
  pkgs,
  lib,
  ...
}: {
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
  };

  services = {
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
    };
    greetd = {
      enable = true;
      settings.initial_session = {
        user = "javier";
        command = "uwsm start hyprland-uwsm.desktop";
      };
      settings.default_session = {
        command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd ${lib.getExe pkgs.zsh}"; # Shell only by default
      };
    };
    # displayManager = {
    #   sessionPackages = [pkgs.hyprland];
    #   #defaultSession = "hyprland-uwsm";
    #   sddm = {
    #     enable = true;
    #     wayland.enable = true;
    #   };
    #   autoLogin = {
    #     enable = true;
    #     user = "javier";
    #   };
    # };
  };
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "launch-hyprland";
      text = ''
        systemctl --user stop graphical-session.target
        uwsm start hyprland-uwsm.desktop
      '';
    })
  ];
}
