{
  flake.nixosModules.grafana = {config, ...}: let
    containerName = "grafana";
  in {
    # systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
    virtualisation.oci-containers = {
      containers = {
        ${containerName} = {
          image = "grafana/${containerName}:main";
          pull = "newer";
          autoStart = true;
          volumes = [
            "${config.my.vars.dockerVolumes}/${containerName}/data/config:/var/lib/grafana"
            "/etc/localtime:/etc/localtime:ro"
          ];
          environment = {
            TZ = config.my.vars.timeZone;
            PUID = "1000";
            GUID = "1000";
            UMASK = "002";
          };
          labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.${containerName}.service" = "${containerName}";
            "traefik.http.services.${containerName}.loadbalancer.server.port" = "3000";
            "traefik.http.routers.${containerName}.middlewares" = "chain-oauth@file";
            "glance.name" = "Grafana";
            "glance.icon" = "si:grafana";
            "glance.id" = "grafana";
          };
        };
      };
    };
  };
}
