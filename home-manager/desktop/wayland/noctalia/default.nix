{
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    settings = {
      colorSchemes.predefinedScheme = lib.mkForce "Nord";
      bar = {
        backgroundOpacity = lib.mkForce 0;
        useSeparateOpacity = true;
        density = "comfortable";
        floating = true;
        widgets = {
          left = [
            {
              id = "Workspace";
              labelMode = "none";
              emptyColor = "none";
              focusedColor = "tertiary";
              occupiedColor = "none";
              # labelMode = "none";
            }
          ];
          center = [
            {id = "Clock";}
          ];
          right = [
            {id = "NotificationHistory";}
            {
              id = "Volume";
              displayMode = "alwaysShow";
            }
            {
              id = "Network";
              displayMode = "alwaysShow";
            }
            {id = "Bluetooth";}
            {
              id = "Battery";
              showPowerProfiles = true;
              showNoctaliaPerformance = true;
            }
            {id = "ControlCenter";}
            {id = "Tray";}
          ];
        };
      };
      ui = {
        fontDefault = lib.mkForce "Atkinson Hyperlegible Next SemiBold";
        fontDefaultScale = 1.1;
        panelsAttachedToBar = false;
        settingsPanelMode = "centered";
      };
      location = {
        name = "Santander";
      };
      dock.enabled = false;
    };
  };
}
