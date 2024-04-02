{pkgs, ...}: {
  boot = {
    plymouth = {
      enable = true;
      # theme = "spinner-monochrome";
      # themePackages = [pkgs.plymouth-spinner-monochrome];
    };
    loader.timeout = 0;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
      "mem_sleep_default=deep"
    ];
  };
}
