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
        // buttons: (
        //   // Gesture button (hold and move)
        //   {
        //     cid: 0xc3;
        //     action = {
        //       type: "Gestures";
        //       gestures: (
        //         {
        //           direction: "None";
        //           mode: "OnRelease";
        //           action = {
        //             type: "Keypress";
        //             keys: [ "KEY_LEFTMETA" ]; // open activities overview
        //           }
        //         },

        //         {
        //           direction: "Right";
        //           mode: "OnRelease";
        //           action = {
        //             type: "Keypress";
        //             keys: [ "KEY_LEFTALT", "KEY_2" ]; // move to virtual desktop 2
        //           }
        //         },

        //         {
        //           direction: "Left";
        //           mode: "OnRelease";
        //           action = {
        //             type: "Keypress";
        //             keys: [ "KEY_LEFTALT", "KEY_1" ]; // move to virtual desktop 1
        //           }
        //         },

        //         {
        //           direction: "Up";
        //           mode: "onRelease";
        //           action = {
        //             type: "Keypress";
        //             keys: [ "KEY_LEFTMETA", "KEY_UP" ]; // maximize window
        //           }
        //         },

        //         {
        //           direction: "Down";
        //           mode: "OnRelease";
        //           action = {
        //             type: "Keypress";
        //             keys: [ "KEY_LEFTMETA", "KEY_DOWN" ]; // minimize window
        //           }
        //         }
        //       );
        //     };
        //   },

        // );
      });
    '';
  };
}
