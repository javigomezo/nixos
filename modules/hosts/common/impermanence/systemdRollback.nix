{
  flake.nixosModules.impermanenceRollback = {config, ...}: let
    diskName =
      if config.my.disko.encryption
      then "mapper/crypted"
      else "disk/by-partlabel/disk-vda-luks";
    afterUnits =
      if config.my.disko.encryption
      then ["systemd-cryptsetup@crypted.service"]
      else [];
  in {
    boot.initrd.systemd.services.rollback = {
      enable = config.my.impermanence.enable;
      description = "Rollback root filesystem to a pristine state on boot";
      wantedBy = [
        "initrd.target"
      ];
      after = afterUnits;
      before = ["sysroot.mount"];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        modprobe nvme
        mkdir /btrfs_tmp

        # Mount the btrfs root to /btrfs_tmp
        mount -t btrfs -o subvol="@" /dev/${diskName} /btrfs_tmp

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
  };
}
