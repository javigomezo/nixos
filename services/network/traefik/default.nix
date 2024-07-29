{config, ...}: {
  imports = [
    ./static_config.nix
    ./dynamic_config.nix
    ./environment_file.nix
  ];

  virtualisation.podman.enable = true;
  virtualisation.oci-containers = {
    containers = {
      whoami = {
        image = "docker.io/traefik/whoami:latest";
        autoStart = true;
        labels = {
          "traefik.enable" = "true";
          "traefik.http.services.whoami.loadbalancer.server.port" = "80";
          "traefik.http.routers.whoami.middlewares" = "chain-no-oauth@file";
          "traefik.http.routers.whoami.tls.certresolver" = "letsencrypt";
        };
      };
    };
  };
  # systemd.services.traefik = {
  #   serviceConfig.EnvironmentFile = [config.sops.templates."traefik.env".path];
  # };
  services.traefik = {
    enable = true;
    group = "podman";
    #environmentFiles = [config.sops.templates."traefik.env".path];
    staticConfigFile = config.sops.templates."static_config.yaml".path;
    dynamicConfigFile = config.sops.templates."dynamic_config.yaml".path;
  };
}
