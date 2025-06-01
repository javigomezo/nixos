{vars, ...}: let
  containerName = "soularr";
  directories = [
    "${vars.dockerVolumes}/${containerName}/data/config"
    "/var/lib/slskd/downloads"
  ];
in {
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
  virtualisation.oci-containers = {
    containers = {
      ${containerName} = {
        image = "mrusse08/${containerName}:latest";
        pull = "newer";
        autoStart = true;
        volumes = [
          "${vars.dockerVolumes}/${containerName}/data/config:/data"
          "/var/lib/slskd/downloads:/downloads"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
          SCRIPT_INTERVAL = "300";
        };
        labels = {
          "traefik.enable" = "false";
        };
      };
    };
  };
}
