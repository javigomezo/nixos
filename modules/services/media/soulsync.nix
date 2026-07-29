{
  flake.nixosModules.soulsync = {config, ...}: let
    containerName = "soulsync";
    directories = [
      "${config.my.vars.dockerVolumes}/${containerName}/data/config"
      "${config.my.vars.dockerVolumes}/${containerName}/data/logs"
      "${config.my.vars.dockerVolumes}/${containerName}/data/staging"
      "${config.my.vars.dockerVolumes}/${containerName}/data/data"
    ];
  in {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
    virtualisation.oci-containers = {
      containers = {
        ${containerName} = {
          image = "boulderbadgedad/${containerName}:latest";
          pull = "newer";
          autoStart = true;
          volumes = [
            "${config.my.vars.dockerVolumes}/${containerName}/data/config:/app/config"
            "${config.my.vars.dockerVolumes}/${containerName}/data/logs:/app/logs"
            "${config.my.vars.dockerVolumes}/${containerName}/data/staging:/app/Staging"
            "${config.my.vars.dockerVolumes}/${containerName}/data/data:/app/data"
            "/var/lib/slskd/downloads:/app/downloads"
            "/mnt/rclone/media/music:/music"
            "/etc/localtime:/etc/localtime:ro"
          ];
          environment = {
            TZ = config.my.vars.timeZone;
            PUID = "1000";
            GUID = "1000";
            UMASK = "002";
            FLASK_ENV = "production";
            PYTHONAPP = "/app";
            SOULSYNC_CONFIG_PATH = "/app/config/config.json";
          };
          labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.${containerName}.service" = "${containerName}";
            "traefik.http.services.${containerName}.loadbalancer.server.port" = "8008";
            "traefik.http.routers.${containerName}.middlewares" = "chain-oauth@file";
            "glance.name" = "Soulsync";
            "glance.parent" = "arr";
          };
        };
      };
    };

    systemd.services.podman-sonarr = {
      after = ["multi-user.target"];
    };
  };
}
