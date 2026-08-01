{
  flake.modules.homeManager.hyprlandAnimations = {lib, ...}: {
    wayland.windowManager.hyprland.settings = {
      config.general = {
        gaps_in = 3;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = lib.mkForce "rgb(81a1c1)";
        layout = "dwindle";
      };
      curve = [
        {
          _args = [
            "windowSpring"
            {
              type = "spring";
              mass = 1;
              stiffness = 600;
              dampening = 40;
            }
          ];
        }
        {
          _args = [
            "wind"
            {
              type = "bezier";
              points = [[0.5 0.9] [0.1 1.05]];
            }
          ];
        }
        {
          _args = [
            "liner"
            {
              type = "bezier";
              points = [[1 1] [1 1]];
            }
          ];
        }
        {
          _args = [
            "default"
            {
              type = "bezier";
              points = [[0.05 0.9] [0.1 1]];
            }
          ];
        }
      ];

      animation = [
        {
          leaf = "windows";
          enabled = true;
          speed = 4;
          spring = "windowSpring";
          style = "slide";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 1;
          bezier = "liner";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 3;
          bezier = "default";
          # style = "loop";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 5;
          bezier = "wind";
        }
      ];
    };
  };
}
