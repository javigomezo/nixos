{
  lib,
  inputs,
  config,
  ...
}: let
  powerOptions = ["lock" "suspend" "reboot" "rebootToUefi" "logout" "shutdown" "hibernate"];
in {
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
              occupiedColor = "primary";
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
            {
              id = "Tray";
              drawerEnabled = false;
            }
            {id = "ControlCenter";}
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
        powerOptions =
          map (i: {
            action = i;
            enabled = i != "hibernate";
          })
          powerOptions;
      };
      ui = {
        fontDefault = lib.mkForce "Atkinson Hyperlegible Next SemiBold";
        fontFixed = lib.mkForce "Atkinson Hyperlegible Next SemiBold";
        fontDefaultScale = 1.1;
        fontFixedScale = 1.1;
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
