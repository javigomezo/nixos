{vars, ...}: let
  containerName = "immich-machine-learning";
  directories = [
    "${vars.dockerVolumes}/immich/ml/data/cache"
  ];
in {
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
  virtualisation.oci-containers = {
    containers = {
      ${containerName} = {
        image = "ghcr.io/immich-app/${containerName}:release-openvino";
        pull = "newer";
        autoStart = true;
        volumes = [
          "${vars.dockerVolumes}/immich/ml/data/cache:/cache"
          "/etc/localtime:/etc/localtime:ro"
        ];
        extraOptions = [
          "--device=/dev/dri:/dev/dri"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
        };
        labels = {
          "traefik.enable" = "false";
        };
      };
    };
  };
}
