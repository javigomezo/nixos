{vars, ...}: let
  containerName = "suggestarr";
  directories = [
    "${vars.dockerVolumes}/${containerName}/data/config"
  ];
in {
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
  virtualisation.oci-containers = {
    containers = {
      ${containerName} = {
        image = "docker.io/ciuse99/${containerName}:latest";
        pull = "newer";
        autoStart = true;
        volumes = [
          "${vars.dockerVolumes}/${containerName}/data/config:/app/config/config_files"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.${containerName}.service" = "${containerName}";
          "traefik.http.services.${containerName}.loadbalancer.server.port" = "5000";
          "traefik.http.routers.${containerName}.middlewares" = "chain-oauth@file";
          "glance.name" = "Suggestarr";
          "glance.parent" = "arr";
        };
      };
    };
  };

  systemd.services.podman-suggestarr = {
    after = ["multi-user.target"];
  };
}
