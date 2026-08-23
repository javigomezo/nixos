{inputs, ...}: {
  flake.modules.homeManager.noctalia = {
    lib,
    config,
    ...
  }: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      settings = {
        wallpaper.default = {
          path = config.stylix.image;
        };
        shell = {
          launch_apps_as_systemd_services = true;
          font_family = lib.mkForce "Atkinson Hyperlegible Next SemiBold";
          lang = "es";
          password_style = "random";
          polkit_agent = true;
          settings_show_advanced = true;
          panel = {
            floating_layer = "top";
            control_center_placement = "floating";
            open_near_click_control_center = true;
            session_placement = "floating";
          };
        };

        bar.widgets.enabled = false;
        bar.main = {
          background_opacity = lib.mkForce 0;
          capsule = true;
          contact_shadow = true;
          margin_edge = 2;
          margin_ends = 2;
          padding = 6;
          start = lib.mkForce ["workspaces"];
          center = ["group:date_group"];
          end = ["notifications" "volume" "group:wireless_group" "battery" "tray" "control-center"];
          capsule_group = [
            {
              id = "date_group";
              fill = "surface_variant";
              members = ["clock" "weather"];
            }
            {
              id = "wireless_group";
              fill = "surface_variant";
              members = ["network" "bluetooth"];
            }
          ];
        };
        widget = {
          workspaces = {
            show_labels = false;
            empty_color = "tertiary";
            occupied_color = "tertiary";
          };
          clock.format = "{:%H:%M, %a %d %b}";
        };
        dock.enabled = false;
        hooks = {
          session_unlocked = "sudo systemctl restart logid";
        };
      };
    };
  };
}
