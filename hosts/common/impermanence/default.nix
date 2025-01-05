{
  lib,
  config,
  ...
}: {
  options.my.impermanence = {
    enable = lib.mkEnableOption {
      description = "Enables impermanence";
      type = lib.types.bool;
    };
    machine-id = lib.mkOption {
      description = "Set machine-id (e.g.0838f4c362294859ab2a451784b12b62)";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.my.impermanence.enable {
    # filesystem modifications needed for impermanence
    fileSystems."/persist".neededForBoot = true;
    fileSystems."/var/log".neededForBoot = true;

    # reset / at each boot
    boot.initrd.systemd.services.rollback = lib.mkIf (config.my.disko.encryption) (import ./systemdRollback.nix);

    boot.initrd.postDeviceCommands = lib.mkIf (! config.my.disko.encryption) (lib.mkAfter import ./initrdRollback.txt);

    # configure impermanence
    environment.persistence."/persist" = {
      hideMounts = true;
      directories =
        [
          "/etc/secureboot"
          "/etc/NetworkManager/system-connections"
          "/var/lib/bluetooth"
          "/var/lib/btrfs"
          "/var/lib/containers"
          "/var/lib/flatpak"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/var/lib/systemd/backlight"
          "/var/lib/tailscale"
          "/var/lib/private"
          {
            directory = "/var/lib/colord";
            user = "colord";
            group = "colord";
            mode = "u=rwx,g=rx,o=";
          }
        ]
        ++ lib.mkIf (config.networking.hostName == "nuc8i3beh") [
          "/var/lib/AdGuardHome"
          {
            directory = "/var/lib/audiobookshelf";
            user = "audiobookshelf";
            group = "audiobookshelf";
            mode = "u=rwx,g=rx,o=";
          }
          {
            directory = "/var/lib/authelia-main";
            user = "authelia-main";
            group = "authelia-main";
            mode = "u=rwx,g=rx,o=";
          }
          {
            directory = "/var/lib/traefik";
            user = "traefik";
            group = "traefik";
            mode = "u=rwx,g=rx,o=";
          }
        ];
      files = [];
    };

    # machine id - setting as a persistent file results in errors.
    # so we use this config option instead:
    environment.etc.machine-id.text = config.my.impermanence.machine-id;
    environment.etc."ssh/ssh_host_rsa_key".source = "/persist/etc/ssh/ssh_host_rsa_key";
    environment.etc."ssh/ssh_host_rsa_key.pub".source = "/persist/etc/ssh/ssh_host_rsa_key.pub";
    environment.etc."ssh/ssh_host_ed25519_key".source = "/persist/etc/ssh/ssh_host_ed25519_key";
    environment.etc."ssh/ssh_host_ed25519_key.pub".source = "/persist/etc/ssh/ssh_host_ed25519_key.pub";

    environment.sessionVariables = {
      PATH = [
        "/persist/nixos/scripts"
      ];
    };
  };
}
