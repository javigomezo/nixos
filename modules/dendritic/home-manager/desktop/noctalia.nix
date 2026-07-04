{inputs, ...}:
# let
# powerOptions = ["lock" "suspend" "reboot" "rebootToUefi" "logout" "shutdown" "hibernate"];
# in
{
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
        notifications.layer = "overlay";
        wallpaper.default = {
          path = config.stylix.image;
        };
        # theme = {
        #   mode = "dark";
        #   source = "builtin";
        #   builtin = "Nord";
        # };
        shell = {
          launch_apps_as_systemd_services = true;
          font_family = lib.mkForce "Atkinson Hyperlegible Next SemiBold";
          lang = "es";
          password_style = "random";
          polkit_agent = true;
          settings_show_advanced = true;
          panel = {
            open_near_click_control_center = true;
            session_placement = "centered";
          };
        };

        control_center.background_opacity = 1;
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
          #   {
          #     id = "Battery";
          #     showPowerProfiles = true;
          #     showNoctaliaPerformance = true;
          #   }

          workspaces = {
            display = "none";
            empty_color = "tertiary";
            occupied_color = "tertiary";
          };
          clock.format = "{:%H:%M, %a %d %b}";
        };
        appLauncher = {
          enableClipboardHistory = true;
          autoPasteClipboard = true;
          enableClipPreview = true;
          clipboardWrapText = true;
        };
        # sessionMenu = {
        #   enableCountdown = false;
        #   largeButtonsLayout = "grid";
        #   powerOptions =
        #     map (i: {
        #       action = i;
        #       enabled = i != "hibernate";
        #     })
        #     powerOptions;
        # };
        location = {
          name = "Santander";
        };
        dock.enabled = false;
      };
    };
  };
}
