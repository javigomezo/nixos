{self, ...}: {
  flake.nixosModules.backups = {
    lib,
    config,
    pkgs,
    ...
  }: {
    sops = {
      secrets."restic/password" = {
        sopsFile = self + "/modules/sops/common/_secrets.yaml";
        format = "yaml";
      };
      templates."restic.password" = {
        content = "${config.sops.placeholder."restic/password"}";
      };
    };

    security.wrappers.restic = {
      source = "${pkgs.restic}/bin/restic";
      owner = "root";
      group = "root";
      permissions = "u=rwx,g=,o=";
      capabilities = "cap_dac_read_search=+ep";
    };

    security.wrappers.fusermount = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${lib.getBin pkgs.fuse3}/bin/fusermount3";
    };

    services.restic.backups."${config.networking.hostName}" = {
      initialize = true;
      user = "root";
      package = pkgs.writeShellApplication {
        name = "restic";
        text = ''
          set -euxo pipefail

          # PrivateMounts are not shared across ExecStartPre and ExecStart,
          # so we have to mount the snapshot again when doing a backup.
          # Any other operation (e.g. restore) must operate on the real /persist,
          # so the snapshot is not mounted for those.
          if [[ "$1" == "backup" ]]; then
            mount --bind /persist/@backup-snapshot /persist
            # umount /persist -l
            # mount -t btrfs -o subvol=@/persist/@backup-snapshot /dev/disk/by-partlabel/disk-vda-luks /persist/
          fi

          ${config.security.wrapperDir}/${config.security.wrappers.restic.program} "$@"
        '';
      };
      paths = ["/persist"];
      exclude = [
        "/persist/@backup-snapshot"
        "/persist/opt/docker-services/qbittorrent/data/downloads"
        "/persist/var/lib/containers"
        "/persist/media"
      ];
      backupPrepareCommand = ''
        set -euxo pipefail

        btrfs subvolume delete /persist/@backup-snapshot || true

        # Create new snapshot
        btrfs subvolume snapshot /persist /persist/@backup-snapshot

        # Unmount /persist
        # umount -l /persist
        # Mount snapshot backup
        # mount -t btrfs -o subvol=@/persist/@backup-snapshot /dev/disk/by-partlabel/disk-vda-luks /persist/
        mount --bind /persist/@backup-snapshot /persist

        # Backup immich postgres
        docker exec immich-postgres pg_dumpall --clean --if-exists --username=immich | gzip > "/persist/opt/docker-services/immich/postgres/dump.sql.gz"
      '';
      backupCleanupCommand = ''
        set -euxo pipefail
        btrfs subvolume delete /persist/@backup-snapshot || true
      '';
      rcloneConfigFile = config.sops.templates."rclone.conf".path;
      repository = "rclone:drive_crypt:/restic/${config.networking.hostName}";
      passwordFile = config.sops.templates."restic.password".path;
      pruneOpts = ["--keep-daily=14"];
      timerConfig = {
        OnCalendar = "00:00";
        Persistent = true;
      };
    };

    systemd.services."restic-backups-${config.networking.hostName}" = {
      path = with pkgs; [
        btrfs-progs
        docker
        gzip
        mount
        umount
      ];
      serviceConfig = {
        # KillMode = "control-group";
        PrivateMounts = true;
      };
    };
  };
}
