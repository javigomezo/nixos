{
  flake.nixosModules.syncthing = {
    lib,
    config,
    ...
  }: let
    devicesList = ["kindle" "workstation" "nuc8i3beh"];
    knownDevices = {
      kindle.id = "NPNF4EC-ITB4BRE-OMTDQLY-Y426DZE-JLKSBR4-H6A6GMQ-ILYITNT-5CO3TQP";
      workstation.id = "DPZGZSP-YC7TUZG-OTDWHEN-2IGJDHA-KTYXQ54-6E52NIJ-MMJJWPY-NHUHIAU";
      nuc8i3beh.id = "CBFLGFC-VNQUQOT-QB7E6AF-EGZO6QI-TNEGTUM-GGL4KBC-3DQOMIP-HU437AT";
    };
  in {
    sops.secrets = {
      "syncthing/cert" = {
        owner = "syncthing";
        group = "syncthing";
        mode = "0600";
      };
      "syncthing/key" = {
        owner = "syncthing";
        group = "syncthing";
        mode = "0600";
      };
    };
    users.users.syncthing.homeMode = "0770";
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      cert = config.sops.secrets."syncthing/cert".path;
      key = config.sops.secrets."syncthing/key".path;
      settings = {
        # gui.insecureSkipHostcheck = true;
        devices = lib.filterAttrs (name: value: name != config.networking.hostName) knownDevices;
        folders = {
          koreader_database = {
            enable = true;
            devices = builtins.filter (device: device != config.networking.hostName) devicesList;
            path = "/var/lib/syncthing/koreader/database";
            ignorePerms = true;
            label = "database";
          };
          libros = {
            enable = true;
            devices = builtins.filter (device: device != config.networking.hostName) devicesList;
            path = "/var/lib/syncthing/koreader/libros";
            ignorePerms = true;
            label = "libros";
          };
        };
      };
    };
    environment = lib.mkIf config.my.impermanence.enable {
      persistence."/persist".directories = lib.mkAfter [
        {
          directory = "/var/lib/syncthing";
          user = "syncthing";
          group = "syncthing";
          mode = "u=rwx,g=rx,o=";
        }
      ];
    };
  };
}
