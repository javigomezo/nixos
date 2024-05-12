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

    boot.initrd.postDeviceCommands = lib.mkIf (! config.my.disko.encryption) (lib.mkAfter import ./initrdRollback.nix);

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
