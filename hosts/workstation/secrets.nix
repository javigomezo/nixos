{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    # secrets = {
    #   fqdn = {};
    #   "traefik/cloudflare_email" = {};
    #   "traefik/cloudflare_api_key" = {};
    # };
  };
}
