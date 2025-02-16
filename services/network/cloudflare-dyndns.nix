{config, ...}: {
  sops = {
    secrets = {
      "cloudflare/dns_api_key" = {};
    };
    templates."apiToken.env" = {
      content = ''
        CLOUDFLARE_API_TOKEN="${config.sops.placeholder."cloudflare/dns_api_key"}"
        CLOUDFLARE_DOMAINS="${config.sops.placeholder.fqdn}"
      '';
    };
  };
  services.cloudflare-dyndns = {
    enable = true;
    proxied = true;
    apiTokenFile = config.sops.templates."apiToken.env".path;
  };
}
