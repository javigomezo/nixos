{pkgs, ...}: {
  services = {
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
    };
    displayManager = {
      sessionPackages = [pkgs.hyprland];
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      autoLogin = {
        enable = true;
        user = "javier";
      };
    };
  };
}
