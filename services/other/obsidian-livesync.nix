{
  config,
  vars,
  ...
}: let
  containerName = "obsidian-livesync";
  directories = [
    "${vars.dockerVolumes}/${containerName}/data"
  ];
in {
  sops = {
    secrets = {
      "obsidian-livesync/couchdb_user" = {};
      "obsidian-livesync/couchdb_password" = {};
    };
    templates."obsidian-livesync.env" = {
      content = ''
        COUCHDB_USER=${config.sops.placeholder."obsidian-livesync/couchdb_user"}
        COUCHDB_PASSWORD=${config.sops.placeholder."obsidian-livesync/couchdb_password"}
      '';
    };
  };
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
  virtualisation.oci-containers = {
    containers = {
      ${containerName} = {
        image = "couchdb:latest";
        autoStart = true;
        volumes = [
          "${vars.dockerVolumes}/${containerName}/data/:/opt/couchdb/data/"
          "${vars.dockerVolumes}/${containerName}/local.ini:/opt/couchdb/etc/local.ini"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environmentFiles = [
          config.sops.templates."obsidian-livesync.env".path
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
          "traefik.http.services.${containerName}.loadbalancer.server.port" = "5984";
          "traefik.http.routers.${containerName}.middlewares" = "chain-no-oauth@file";
          # Adhoc middlewares
          "traefik.http.middlewares.obsidiancors.headers.accesscontrolallowmethods" = "GET,PUT,POST,HEAD,DELETE";
          "traefik.http.middlewares.obsidiancors.headers.accesscontrolallowheaders" = "accept,authorization,content-type,origin,referer";
          "traefik.http.middlewares.obsidiancors.headers.accesscontrolalloworiginlist" = "app://obsidian.md,capacitor://localhost,http://localhost";
          "traefik.http.middlewares.obsidiancors.headers.accesscontrolmaxage" = "3600";
          "traefik.http.middlewares.obsidiancors.headers.addvaryheader" = "true";
          "traefik.http.middlewares.obsidiancors.headers.accessControlAllowCredentials" = "true";
        };
      };
    };
  };
}
