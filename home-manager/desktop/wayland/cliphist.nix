{
  services.cliphist = {
    enable = true;
  };
  systemd.user.services.cliphist = {
    Unit.After = ["graphical-session.target"];
  };
  systemd.user.services.cliphist-images = {
    Unit.After = ["graphical-session.target"];
  };
}
