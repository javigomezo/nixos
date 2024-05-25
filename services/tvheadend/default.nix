{vars, ...}: let
  directories = [
    "${vars.dockerVolumes}/tvheadend/data/config"
    # "${vars.dockerVolumes}/tvheadend/lists"
  ];
in {
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
          # "${vars.dockerVolumes}/tvheadend/data/lists:/usr/share/tvheadend/data/dvb-scan/dvb-t:ro"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
        };
        extraOptions = [
          "--device=/dev/gpiomem:/dev/dvb"
        ];
      };
    };
  };
}
