{config, ...}: {
  sops = {
    secrets = {
      "cloudflare/dns_api_key" = {};
    };
    templates."apiToken.env" = {
      content = ''
        ${config.sops.placeholder."cloudflare/dns_api_key"}
      '';
    };
    templates."domainName.env".content = ''
      CLOUDFLARE_DOMAINS="${config.sops.placeholder.fqdn}"
    '';
  };
  services.cloudflare-dyndns = {
    enable = true;
    proxied = true;
    apiTokenFile = config.sops.templates."apiToken.env".path;
  };
  systemd.services.cloudflare-dyndns = {
    serviceConfig.EnvironmentFile = [config.sops.templates."domainName.env".path];
  };
}
