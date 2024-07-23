# Host Y520

# How to Install
```bash
  nix run github:nix-community/nixos-anywhere -- --copy-host-key --no-reboot --flake github:javigomezo/nixos#y520 root@<target_host>
```
## Before reboot
As impermanence is active it's needed to copy the host keys to the right path. SSH again into the host and:

```bash
mount /dev/mapper/crypted /mnt && \
mkdir -p /mnt/@/persist/etc/ssh && \
cp /etc/ssh/ssh_host_* /mnt/@/persist/etc/ssh/
```

# Post Install

At the time of writing this there is no declarative way of configuring flatpaks (at least not an official one). So here are some needed steps to have everything working.

## FDE + TPM2 Unlock

If secureboot is disabled:

```bash
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0 /dev/mapper/crypted
```

If secureboot is enabled:

```bash
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/mapper/crypted
```

## Add flathub repo and install Plex and Flatseal
```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
flatpak install flathub tv.plex.PlexDesktop && \
flatpak install flathub com.github.tchx84.Flatseal
```

## Plex post install
```bash
flatpak override --user --socket=fallback-x11 --device=all --env=__GLX_VENDOR_LIBRARY_NAME=nvidia --env=__NV_PRIME_RENDER_OFFLOAD=1 --env=QT_QPA_PLATFORM=xcb --env=GBM_BACKEND=nvidia --env=QT_STYLE_OVERRIDE="" tv.plex.PlexDesktop
```
