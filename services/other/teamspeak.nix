{vars, ...}: let
  containerName = "teamspeak";
  directories = [
    "${vars.dockerVolumes}/${containerName}/data/config"
  ];
in {
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
  virtualisation.oci-containers = {
    containers = {
      ${containerName} = {
        image = "lscr.io/linuxserver/${containerName}:latest";
        autoStart = true;
        volumes = [
          "${vars.dockerVolumes}/${containerName}/data/:/var/ts3server"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
          TS3SERVER_LICENSE = "accept";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.udp.routers.${containerName}.entrypoints" = "${containerName}";
          "traefik.udp.routers.${containerName}.service" = "${containerName}";
          "traefik.udp.services.${containerName}.loadbalancer.server.port" = "9987";
        };
      };
    };
  };
}
