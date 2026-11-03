{self, ...}: {
  flake.nixosModules.backups = {
    lib,
    config,
    pkgs,
    ...
  }: let
    host = config.networking.hostName;
    snapshot = "/persist/@backup-snapshot";
    dump = "/persist/opt/docker-services/immich/postgres/dump.sql.gz";
  in {
    sops.secrets."restic/password" = {
      sopsFile = self + "/modules/sops/common/_secrets.yaml";
      format = "yaml";
    };

    # Needed for `restic mount` as it uses fusermount and not fusermount3
    security.wrappers.fusermount = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${lib.getBin pkgs.fuse3}/bin/fusermount3";
    };

    services.restic.backups.${host} = {
      initialize = true;
      user = "root";

      package = pkgs.writeShellApplication {
        name = "restic";
        runtimeInputs = [pkgs.util-linux];
        text = ''
          if [[ "''${1:-}" == "backup" ]]; then
            mount --bind ${snapshot} /persist
          fi
          exec ${pkgs.restic}/bin/restic "$@"
        '';
      };

      paths = ["/persist"];
      exclude = [
        "/persist/opt/docker-services/qbittorrent/data/downloads"
        "/persist/var/lib/containers"
        "/persist/media"
      ];

      backupPrepareCommand = ''
        set -euo pipefail
        umask 077

        # Immich postgres dump
        docker exec immich-postgres pg_dumpall --clean --if-exists --username=immich \
          | gzip > "${dump}.tmp"
        mv "${dump}.tmp" "${dump}"

        # Fresh read-only snapshot (remove a stale one if a previous run died).
        if [ -e ${snapshot} ]; then
          btrfs subvolume delete ${snapshot}
        fi
        btrfs subvolume snapshot -r /persist ${snapshot}
      '';

      backupCleanupCommand = ''
        set -euo pipefail
        if [ -e ${snapshot} ]; then
          btrfs subvolume delete ${snapshot}
        fi
      '';

      rcloneConfigFile = config.sops.templates."rclone.conf".path;
      # Don't leave deleted packs in Drive's trash (they count against quota).
      rcloneOptions.drive-use-trash = "false";
      repository = "rclone:drive_crypt:/restic/${host}";
      passwordFile = config.sops.secrets."restic/password".path;

      pruneOpts = [
        "--keep-daily=14"
        "--keep-weekly=8"
        "--keep-monthly=12"
        "--keep-yearly=2"
      ];

      timerConfig = {
        OnCalendar = "00:00";
        Persistent = true;
      };
    };

    systemd.services."restic-backups-${host}" = {
      path = with pkgs; [
        btrfs-progs
        docker
        gzip
        util-linux
      ];
      serviceConfig = {
        PrivateMounts = true;
        Nice = 10;
        IOSchedulingClass = "idle";
      };
    };
  };
}
