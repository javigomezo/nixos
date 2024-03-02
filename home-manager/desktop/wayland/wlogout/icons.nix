{
  inputs,
  config,
  ...
}: {
  home.file = {
    ".config/wlogout/icons" = {
      source = config.lib.file.mkOutOfStoreSymlink ./icons;
      recursive = true;
    };
  };
}
