{ outputs, config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or  [ ]) ++ [ "-Dexperimental=true" ];
    });
    systemd.enable = true;
    settings =
      {
        primary = {
          layer = "top";
          position = "top";
          mod = "dock";
          exclusive = true;
          passthrough = false;
          gtk-layer-shell = true;
          #height = "auto";
          #width = "auto";
          modules-left = [ "clock" "custom/weather" "wlr/workspaces" ];
          modules-center = ["hyprland/window"];
          modules-right = [ "pulseaudio" "network" "temperature" "tray" ];
          clock = {
            interval = 1;
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
            format = "{: %Y-%m-%d  %H:%M}";
            format-alt = "{: %H:%M}";
          };
          "custom/weather" = {
            tooltip = true;
            format = "{}";
            restart-interval = 30;
            exec = "~/.config/waybar/scripts/waybar-wttr.py";
            return-type = "json";
          };
          "wlr/workspaces" = {
      	    disable-scroll = true;
            on-click = "activate";
      	    all-outputs = true;
            sort-by-number = true;
      	    persistent_workspaces = {
              "1" = [];
              "2" = [];
              "3" = [];
              "4" = [];
      	    };
          };
          "hyprland/window" = {
            format = " {}";
            separate-outputs = true;
          };
          pulseaudio = {
            format = "{icon}  {volume}%  {format_source}";
            format-bluetooth = "{volume}% {icon}  {format_source}";
            format-bluetooth-muted = " {icon}  {format_source}";
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
              default = [ "" "" "" ];
            };
            on-click = "pavucontrol";
          };
          network = {
            format-wifi = " {essid} ({signalStrength}%)";
            format-ethernet = " {ipaddr}/{cidr}";
            tooltip-format = " {ifname} via {gwaddr}";
            format-linked = " {ifname} (No IP)";
            format-disconnected = "⚠ Disconnected";
            format-alt = "{ifname}= {ipaddr}/{cidr}";
          };
          tray = {
            spacing = 15;
          };
        };
      };
    style = builtins.readFile ./style.css;
  };
}
