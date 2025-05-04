{
  lib,
  config,
  vars,
  ...
}: {
  imports = [
    ./systemdRollback.nix
  ];
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

    # reset / at each boot (no secureboot)
    #boot.initrd.postDeviceCommands = lib.mkIf (! config.my.boot.secureboot.enable) (import ./initrdRollback.txt);

    # configure impermanence
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = lib.mkMerge [
        [
          "/var/lib/sbctl"
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
        (lib.mkIf (config.networking.hostName == "nuc8i3beh") [
          {
            directory = "/media/music";
            user = "javier";
            group = "javier";
            mode = "u=rwx,g=rwx,o=";
          }
          {
            directory = "${vars.dockerVolumes}";
            user = "javier";
            group = "javier";
            mode = "u=rwx,g=rwx,o=";
          }
        ])
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
