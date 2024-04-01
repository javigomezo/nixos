# btrfs/impermanence.nix
{
  lib,
  config,
  pkgs,
  ...
}: {
  #users.users.${myuser} = {
  #  hashedPasswordFile = "/persist/passwords/user";
  #};

  # filesystem modifications needed for impermanence
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  # reset / at each boot
  # Note `lib.mkBefore` is used instead of `lib.mkAfter` here.
  boot.initrd.postDeviceCommands = lib.mkBefore ''
    mkdir -p /mnt

    # Mount the btrfs root to /mnt
    mount -o subvol="@" /dev/nvme0n1p3 /mnt

    # Delete the root subvolume
    echo "deleting root subvolume..." &&
    btrfs subvolume delete /mnt/root

    # Restore new root from root-blank
    echo "restoring blank @root subvolume..."
    btrfs subvolume list -o /mnt/root |
    cut -f9 -d' ' |
    while read subvolume; do
      echo "deleting /$subvolume subvolume..."
      btrfs subvolume delete "/mnt/$subvolume"
    done &&
    echo "deleting /root subvolume..." &&
    btrfs subvolume delete /mnt/root

    echo "restoring blank /root subvolume..."
    btrfs subvolume snapshot /mnt/root-blank /mnt/root

    # Unmount /mnt and continue boot process
    umount /mnt
  '';

  # configure impermanence
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [];
  };

  # machine id - setting as a persistent file results in errors.
  # so we use this config option instead:
  environment.etc.machine-id.source = ./machine-id;
  environment.etc."ssh/ssh_host_rsa_key".source = "/persist/etc/ssh/ssh_host_rsa_key";
  environment.etc."ssh/ssh_host_rsa_key.pub".source = "/persist/etc/ssh/ssh_host_rsa_key.pub";
  environment.etc."ssh/ssh_host_ed25519_key".source = "/persist/etc/ssh/ssh_host_ed25519_key";
  environment.etc."ssh/ssh_host_ed25519_key.pub".source = "/persist/etc/ssh/ssh_host_ed25519_key.pub";

  # security.sudo.extraConfig = ''
  #   # rollback results in sudo lectures after each reboot
  #   Defaults lecture = never
  # '';

  environment.sessionVariables = {
    PATH = [
      "/persist/nixos/scripts"
    ];
  };
}
