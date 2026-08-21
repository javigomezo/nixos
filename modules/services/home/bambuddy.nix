{
  flake.nixosModules.bambuddy = {config, ...}: let
    containerName = "bambuddy";
    directories = [
      "${config.my.vars.dockerVolumes}/${containerName}/data/config"
      "${config.my.vars.dockerVolumes}/${containerName}/data/logs"
    ];
  in {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
    virtualisation.oci-containers = {
      containers = {
        ${containerName} = {
          image = "ghcr.io/maziggy/${containerName}:latest";
          pull = "newer";
          autoStart = true;
          capabilities = {
            NET_BIND_SERVICE = true;
          };
          volumes = [
            "${config.my.vars.dockerVolumes}/${containerName}/data/config:/app/data"
            "${config.my.vars.dockerVolumes}/${containerName}/data/logs:/app/logs"
            "/etc/localtime:/etc/localtime:ro"
          ];
          environment = {
            TZ = config.my.vars.timeZone;
            PUID = "1000";
            GUID = "1000";
            UMASK = "002";
            PORT = "8012";
          };
          extraOptions = [
            "--network=host"
          ];
          labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.${containerName}.service" = "${containerName}";
            "traefik.http.services.${containerName}.loadbalancer.server.port" = "8012";
            "traefik.http.routers.${containerName}.middlewares" = "chain-oauth@file";
          };
        };
      };
    };

    systemd.services.podman-sonarr = {
      after = ["multi-user.target"];
    };
  };
}
