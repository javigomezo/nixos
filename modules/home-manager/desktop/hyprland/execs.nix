{
  flake.modules.homeManager.hyprlandExecs = {
    lib,
    config,
    ...
  }: {
    wayland.windowManager.hyprland.settings = {
      on = {
        _args = [
          "hyprland.start"
          (lib.generators.mkLuaInline ''
            function()
              hl.exec_cmd("${lib.getExe config.programs.hyprlock.package}")
              hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
              hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,pkcs11,ssh")
              hl.exec_cmd("hyprctl setcursor bibata-modern-classic-hyprcursor 24")
            end
          '')
        ];
      };
    };
  };
}
