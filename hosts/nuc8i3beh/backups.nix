{
  config,
  pkgs,
  ...
}: {
  sops = {
    secrets."restic/password" = {
      sopsFile = ../common/secrets.yaml;
      format = "yaml";
    };
    templates."restic.password" = {
      content = "${config.sops.placeholder."restic/password"}";
    };
  };

  services.restic.backups."${config.networking.hostName}" = {
    initialize = true;
    paths = ["/persist"];
    exclude = [
      "/persist/@backup-snapshot"
      "/persist/opt/docker-services/qbittorrent/data/downloads"
      "/persist/var/lib/containers"
      "/persist/media"
    ];
    backupPrepareCommand = ''
      set -Eeuxo pipefail

      # Clean old snapshot if any
      if btrfs subvolume delete /persist/@backup-snapshot; then
        echo "WARNING: previous run did not cleanly finish, removing old snapshot"
      fi

      # Create new snapshot
      btrfs subvolume snapshot -r /persist /persist/@backup-snapshot

      # Unmount /persist
      umount -l /persist
      # Mount snapshot backup
      mount -t btrfs -o subvol=@/persist/@backup-snapshot /dev/disk/by-partlabel/disk-vda-luks /persist/
    '';
    backupCleanupCommand = ''
      btrfs subvolume delete /persist/@backup-snapshot
    '';
    rcloneConfigFile = config.sops.templates."rclone.conf".path;
    repository = "rclone:drive_crypt:/restic/${config.networking.hostName}";
    passwordFile = config.sops.templates."restic.password".path;
    pruneOpts = ["--keep-daily=7"];
    timerConfig = {
      OnCalendar = "03:00";
      Persistent = true;
    };
  };

  systemd.services."restic-backups-${config.networking.hostName}" = {
    path = with pkgs; [
      btrfs-progs
      umount
      mount
    ];
    serviceConfig = {
      KillMode = "control-group";
      PrivateMounts = true;
    };
  };
}
