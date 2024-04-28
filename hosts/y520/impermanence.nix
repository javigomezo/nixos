# btrfs/impermanence.nix
{
  #users.users.${myuser} = {
  #  hashedPasswordFile = "/persist/passwords/user";
  #};

  # filesystem modifications needed for impermanence
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  # reset / at each boot
  # Note `lib.mkBefore` is used instead of `lib.mkAfter` here.
  boot.initrd.systemd.services.rollback = {
    description = "Rollback root filesystem to a pristine state on boot";
    wantedBy = [
      "initrd.target"
    ];
    after = [
      "systemd-cryptsetup@enc.service"
    ];
    before = [
      "sysroot.mount"
    ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir /btrfs_tmp

      # Mount the btrfs root to /btrfs_tmp
      mount -o subvol="@" /dev/mapper/crypted /btrfs_tmp

      # Delete the root subvolume
      btrfs subvolume list -o /btrfs_tmp/root | cut -f9 -d' ' | cut -c2- |
      while read subvolume; do
        echo "deleting /$subvolume subvolume..."
        btrfs subvolume delete "/btrfs_tmp/$subvolume"
      done &&
      echo "deleting /root subvolume..." &&
      btrfs subvolume delete /btrfs_tmp/root

      echo "restoring blank /root subvolume..."
      btrfs subvolume snapshot /btrfs_tmp/root-blank /btrfs_tmp/root

      # Unmount /btrfs_tmp and continue boot process
      umount /btrfs_tmp
    '';
  };

  # configure impermanence
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/flatpak"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/backlight"
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
