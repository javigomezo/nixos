{config, ...}: {
  sops = {
    templates."apiToken.env" = {
      content = ''
        CLOUDFLARE_API_TOKEN="${config.sops.placeholder."traefik/cloudflare_api_key"}"
        CLOUDFLARE_DOMAINS="${config.sops.placeholder.fqdn}"
      '';
    };
  };
  services.cloudflare-dyndns = {
    enable = true;
    apiTokenFile = config.sops.templates."apiToken.env".path;
  };
}
