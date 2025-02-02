{vars, ...}: let
  containerName = "immich";
  directories = [
    "${vars.dockerVolumes}/${containerName}/data/"
  ];
in {
  services.immich = {
    enable = true;
    mediaLocation = "${vars.dockerVolumes}/${containerName}/data/";
    openFirewall = true;
  };
}
