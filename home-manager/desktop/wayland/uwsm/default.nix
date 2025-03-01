{
  config,
  vars,
  ...
}: {
  home.file."${config.home.homeDirectory}/.config/uwsm/env-hyprland" = {
    enable = true;
    text = ''
      export HYPRCURSOR_THEME="bibata-modern-classic-hyprcursor"
      export HYPRCURSOR_SIZE=24
    '';
  };
  home.file."${config.home.homeDirectory}/.config/uwsm/env" = {
    enable = true;
    text = ''
      export XDG_CURRENT_DESKTOP=Hyprland
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=Hyprland
      export WLR_NO_HARDWARE_CURSORS=1
      export MOZ_ENABLE_WAYLAND=1
      export MOZ_USA_XINPUT2=1
      export NIXPKGS_ALLOW_UNFREE=1
      export QT_QPA_PLATFORM="wayland;xcb"
      export LIBSEAT_BACKEND="logind"
      export FLAKE="${config.home.homeDirectory}/nixos"
      export NIXOS_OZONE_WL=1
      export GBM_BACKEND=nvidia-drm
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export LIBVA_DRIVER_NAME=${vars.libva_driver}
      export __GL_VRR_ALLOWED=0
    '';
  };
}
