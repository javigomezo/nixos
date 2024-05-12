''
mkdir /btrfs_tmp

# Mount the btrfs root to /btrfs_tmp
mount -o subvol="@" /dev/nvme0n1p3 /btrfs_tmp

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
