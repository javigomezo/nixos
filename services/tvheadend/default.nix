{
  config,
  vars,
  ...
}: let
  directories = [
    "${vars.dockerVolumes}/tvheadend/data/config"
  ];
in {
  imports = [
    ./tdt-list.nix
  ];
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
  virtualisation.oci-containers = {
    containers = {
      tvheadend = {
        image = "lscr.io/linuxserver/tvheadend:latest";
        autoStart = true;
        ports = [
          "9981:9981"
        ];
        volumes = [
          "${vars.dockerVolumes}/tvheadend/data/config:/config"
          "${config.sops.templates.tdt-channels.path}:/usr/share/tvheadend/data/dvb-scan/dvb-t/es-Santander:ro"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
        };
        extraOptions = [
          "--device=/dev/dvb:/dev/dvb"
        ];
      };
    };
  };
}
