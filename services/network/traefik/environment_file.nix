{config, ...}: {
  sops.templates."traefik.env" = {
    owner = "traefik";
    path = "/var/lib/traefik/traefik.env";
    content = ''
      CLOUDFLARE_EMAIL=${config.sops.placeholder."traefik/cloudflare_email"}
      CLOUDFLARE_API_KEY=${config.sops.placeholder."traefik/cloudflare_api_key"}
      DOMAIN=${config.sops.placeholder.fqdn}
    '';
  };
}
