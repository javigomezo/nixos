{config, ...}: {
  # sops.secrets = {
  #   cloudflare_email = {
  #     sopsFile = ../../hosts/common/secrets.yaml;
  #     format = "yaml";
  #   };
  #   cloudflare_api_key = {
  #     sopsFile = ../../hosts/common/secrets.yaml;
  #     format = "yaml";
  #   };
  # };
  sops.templates."traefik.env" = {
    owner = "traefik";
    path = "/var/lib/traefik/traefik.env";
    content = ''
      CLOUDFLARE_EMAIL=${config.sops.placeholder.cloudflare_email}
      CLOUDFLARE_API_KEY=${config.sops.placeholder.cloudflare_api_key}
    '';
  };
}
