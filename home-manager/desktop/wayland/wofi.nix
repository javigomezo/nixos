{
  lib,
  config,
  ...
}: {
  programs.wofi = {
    enable = true;
    settings = {
      location = "center";
      launch_prefix = "uwsm app --";
      show = "drun";
      matching = "fuzzy";
      prompt = "Buscar...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 28;
      gtk_dark = true;
      term = lib.getExe config.programs.kitty.package;
    };
  };
}
