{
  config,
  pkgs,
  vars,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      primary = {
        layer = "top";
        position = "top";
        mod = "dock";
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        modules-left = ["hyprland/workspaces" "custom/weather"];
        # modules-center = ["hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "backlight" "network" "battery" "temperature" "tray"];
        clock = {
          interval = 1;
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          format = " {:%Y-%m-%d  %H:%M}";
          format-alt = " {:%H:%M}";
        };
        "custom/weather" = {
          tooltip = true;
          format = "{}";
          restart-interval = 30;
          exec = "${config.home.homeDirectory}/.config/waybar/scripts/waybar-wttr.py";
          return-type = "json";
        };
        "hyprland/workspaces" = {
          disable-scroll = true;
          on-click = "activate";
          all-outputs = true;
          sort-by-number = true;
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
          };
          format = "{icon}";
          format-icons = {
            default = "";
            # focused = "";
            urgent = "";
          };
        };

        # "hyprland/window" = {
        #   format = " {}";
        #   separate-outputs = true;
        # };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{volume}% {icon} ";
          format-bluetooth-muted = " {icon} ";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        backlight = {
          format = "{icon} {percent}%";
          format-icons = ["" "" "" "" "" "" "" "" ""];
        };
        network = {
          format-wifi = " {essid}";
          format-ethernet = "󰈀 {ipaddr}/{cidr}";
          tooltip-format = "󰈀 {ifname} via {gwaddr}";
          format-linked = "󰈂 {ifname} (No IP)";
          format-disconnected = "⚠ Disconnected";
          format-alt = "{ifname}= {ipaddr}/{cidr}";
        };
        battery = {
          states = {
            "good" = 60;
            "warning" = 30;
            "critical" = 20;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };
        temperature = {
          thermal-zone = vars.thermal_zone;
        };
        tray = {
          spacing = 15;
        };
      };
    };
    style = builtins.readFile ./style.css;
  };
  home.file = {
    ".config/waybar/scripts" = {
      source = config.lib.file.mkOutOfStoreSymlink ./scripts;
      recursive = true;
    };
  };
}
