{
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell Service";
      PartOf = ["graphical-session.target"];
      Requisite = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${lib.getExe config.programs.noctalia-shell.package}";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

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
      appLauncher = {
        enableClipboardHistory = true;
        autoPasteClipboard = true;
        enableClipPreview = true;
        clipboardWrapText = true;
      };
      sessionMenu = {
        enableCountdown = false;
        largeButtonsLayout = "grid";
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
