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
              hl.exec_cmd("hyprctl setcursor bibata-modern-classic-hyprcursor 24")
            end
          '')
        ];
      };
    };
  };
}
