{
  config,
  vars,
  ...
}: let
  containerName = "homeassistant";
  directories = [
    "${vars.dockerVolumes}/${containerName}/data/data"
    "${vars.dockerVolumes}/ha_mariadb/data/config"
  ];
in {
  sops = {
    secrets = {
      "homeassistant/mysql_root_password" = {};
      "homeassistant/mysql_user" = {};
      "homeassistant/mysql_password" = {};
      "homeassistant/mysql_database" = {};
    };
    templates."ha_mariadb.env" = {
      content = ''
        MYSQL_ROOT_PASSWORD=${config.sops.placeholder."homeassistant/mysql_root_password"}
        MYSQL_USER=${config.sops.placeholder."homeassistant/mysql_user"}
        MYSQL_PASSWORD=${config.sops.placeholder."homeassistant/mysql_password"}
        MYSQL_DATABASE=${config.sops.placeholder."homeassistant/mysql_database"}
      '';
    };
  };
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
  virtualisation.oci-containers = {
    containers = {
      ha_mariadb = {
        image = "lscr.io/linuxserver/mariadb:latest";
        pull = "newer";
        autoStart = true;
        volumes = [
          "${vars.dockerVolumes}/${containerName}/data/config:/config"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environmentFiles = [
          config.sops.templates."ha_mariadb.env".path
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
        };
        labels = {
          "traefik.enable" = "false";
          "glance.name" = "MariaDB";
          "glance.parent" = "homeassistant";
        };
      };
      ${containerName} = {
        image = "lscr.io/linuxserver/${containerName}:latest";
        pull = "newer";
        autoStart = true;
        volumes = [
          "${vars.dockerVolumes}/${containerName}/data/config:/config"
          "/etc/localtime:/etc/localtime:ro"
        ];
        # environmentFiles = [
        #   config.sops.templates."ha_mariadb.env".path
        # ];
        environment = {
          TZ = vars.timeZone;
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
          DOCKER_MODS = "linuxserver/mods/homeassistant-hacs";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.${containerName}.service" = "${containerName}";
          "traefik.http.services.${containerName}.loadbalancer.server.port" = "8123";
          "traefik.http.routers.${containerName}.middlewares" = "chain-no-oauth@file";
          # UDP Router
          "traefik.udp.routers.${containerName}.entrypoints" = "${containerName}";
          "traefik.udp.routers.${containerName}.service" = "${containerName}";
          "traefik.udp.services.${containerName}.loadbalancer.server.port" = "5683";
          "glance.name" = "HomeAssistant";
          "glance.icon" = "si:homeassistant";
          "glance.id" = "homeassistant";
        };
      };
    };
  };
}
