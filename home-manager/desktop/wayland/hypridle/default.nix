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
  programs.hypridle = {
    enable = true;
    lockCmd = "pidof hyprlock || hyprlock";
    beforeSleepCmd = "loginctl lock-session";
    afterSleepCmd = "hyprctl dispatch dpms on";
    listeners.options = [
      {
        timeout = 300;
        on-timeout = "loginctl lock-session";
      }
      {
        timeout = 380;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
      {
        timeout = 600;
        on-timeout = "systemctl suspend";
      }
    ];
  };
}
