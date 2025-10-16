{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    logiops
  ];
  systemd.packages = [pkgs.logiops];
  systemd.services.logid.wantedBy = ["multi-user.target"];

  environment.etc."logid.cfg" = {
    text = ''
      devices: ({
        name: "MX Master 4 for Business";

      thumbwheel:
      {
          divert: true;
          invert: false;
          left:
          {
              threshold: 3;
              interval: 2;
              direction: "Left";
              mode: "OnInterval";
              action =
              {
                  type: "Keypress";
                  keys: ["KEY_VOLUMEDOWN"];
              };
          };
          right:
          {
              threshold: 3;
              interval: 2;
              direction: "Right";
              mode: "OnInterval";
              action =
              {
                  type: "Keypress";
                  keys: ["KEY_VOLUMEUP"];
              };
          };
      };
        buttons: (
          // Gesture button (hold and move)
          {
            cid: 0x1a0;
            action = {
              type: "Gestures";
              gestures: (
                {
                  direction: "None";
                  mode: "OnRelease";
                  action = {
                    type: "Keypress";
                    keys: [ "KEY_LEFTMETA", "KEY_R" ]; // open wofi
                  }
                },

                {
                  direction: "Right";
                  mode: "OnRelease";
                  action = {
                    type: "Keypress";
                    keys: [ "KEY_LEFTMETA", "KEY_RIGHT" ]; // move to next virtual workspace
                  }
                },

                {
                  direction: "Left";
                  mode: "OnRelease";
                  action = {
                    type: "Keypress";
                    keys: [ "KEY_LEFTMETA", "KEY_LEFT" ]; // move to previous virtual workspace
                  }
                },

                {
                  direction: "Up";
                  mode: "onRelease";
                  action = {
                    type: "Keypress";
                    keys: [ "KEY_LEFTMETA", "KEY_SPACE" ]; // Maximise/minimise window
                  }
                },

                {
                  direction: "Down";
                  mode: "OnRelease";
                  action = {
                    type: "Keypress";
                    keys: [ "KEY_LEFTMETA", "KEY_C" ]; // Close window
                  }
                }
              );
            };
          },

        );
      });
    '';
  };
}
