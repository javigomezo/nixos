{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      fqdn = {};
      cloudflare_email = {};
      cloudflare_api_key = {};
    };
  };
}
