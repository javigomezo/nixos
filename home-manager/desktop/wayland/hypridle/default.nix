{
  inputs,
  config,
  lib,
  vars,
  ...
}: {
  imports = [
    inputs.hypridle.homeManagerModules.hypridle
  ];
  services.hypridle = {
    enable = true;
    lockCmd = "pidof hyprlock || hyprlock";
    beforeSleepCmd = "loginctl lock-session";
    afterSleepCmd = "hyprctl dispatch dpms on";
    listeners = [
      {
        timeout = 300;
        onTimeout = "loginctl lock-session";
      }
      {
        timeout = 300;
        onTimeout = "pidof hyprlock || hyprlock";
      }
      {
        timeout = 380;
        onTimeout = "hyprctl dispatch dpms off";
        onResume = "hyprctl dispatch dpms on";
      }
      {
        timeout = 600;
        onTimeout = "systemctl suspend";
      }
    ];
  };
}
