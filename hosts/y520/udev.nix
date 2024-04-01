{pkgs, ...}: {
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.cooreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';
}
