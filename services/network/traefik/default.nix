{config, ...}: {
  imports = [
    ./static_config.nix
    ./dynamic_config.nix
    ./environment_file.nix
  ];

  virtualisation.podman.enable = true;
  systemd.services.traefik = {
    serviceConfig.EnvironmentFile = [config.sops.templates."traefik.env".path];
  };
  services.traefik = {
    enable = true;
    group = "podman";
    #environmentFiles = [config.sops.templates."traefik.env".path];
    staticConfigFile = config.sops.templates."static_config.yaml".path;
    dynamicConfigFile = config.sops.templates."dynamic_config.yaml".path;
  };
}
