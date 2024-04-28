# Host Y520

# How to Install
```bash
  $ nix run github:nix-community/nixos-anywhere -- --copy-host-key --flake github:javigomezo/nixos#y520 root@<target_host>
```

# Post Install

At the time of writing this there is no declarative way of configuring flatpaks (at least not an official one). So here are some needed steps to have everything working.

## Add flathub repo and install Plex and Flatseal
```bash
  $ flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  $ flatpak install flathub tv.plex.PlexDesktop
  $ flatpak install flathub com.github.tchx84.Flatseal
```

## Plex post install
```bash
  $ flatpak override --user --env=__GLX_VENDOR_LIBRARY_NAME=nvidia --env=__NV_PRIME_RENDER_OFFLOAD=1 --env=QT_QPA_PLATFORM=xcb --env=GBM_BACKEND=nvidia tv.plex.PlexDesktop
  $ flatpak override --user --socket=fallback-x11 --device=all tv.plex.PlexDesktop
```
