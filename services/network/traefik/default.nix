{
  lib,
  config,
  ...
}: {
  imports = [
    # ./static_config.nix
    ./dynamic_config.nix
    ./environment_file.nix
  ];

  sops = {
    secrets = {
      fqdn = {};
      "traefik/cloudflare_email" = {};
      "traefik/cloudflare_api_key" = {};
    };
  };

  systemd.services.traefik = {
    serviceConfig.EnvironmentFile = [config.sops.templates."traefik.env".path];
    after = ["podman.socket" "podman-sonarr.service" "multi-user.target"]; # TODO: check why containers are not detected after traefik starts
  };

  services.traefik = {
    enable = true;
    group = "podman";
    staticConfigOptions = {
      global = {
        checkNewVersion = false;
        sendAnonymousUsage = false;
      };
      api = {
        insecure = false;
        dashboard = true;
      };
      log = {
        level = "INFO";
        compress = true;
      };
      entrypoints = {
        web = {
          address = ":80";
          asDefault = true;
          http.redirections.entryPoint = {
            to = "websecure";
            permanent = true;
            scheme = "https";
          };
        };
        websecure = {
          address = ":443";
          asDefault = true;
          http3.advertisedPort = 443;
          http.tls = {
            certResolver = "letsencrypt";
            domains = [
              {
                main = "$DOMAIN";
                sans = ["*.$DOMAIN"];
              }
            ];
          };
        };
        teamspeak = {
          address = ":9987/udp";
          udp.timeout = 10;
        };
      };
      certificatesResolvers = {
        letsencrypt.acme = {
          email = "$CLOUDFLARE_EMAIL";
          storage = "${config.services.traefik.dataDir}/acme.json";
          keyType = "EC384";
          dnsChallenge = {
            provider = "cloudflare";
            delayBeforeCheck = "90s";
            resolvers = ["1.1.1.1:53" "1.0.0.1:53"];
          };
        };
      };
      providers = {
        docker = {
          endpoint = "unix:///run/podman/podman.sock";
          allowEmptyServices = true;
          exposedByDefault = false;
          defaultRule = "Host(`{{ normalize .Name }}.{{ env \"DOMAIN\" }}`)";
        };
      };
    };
    environmentFiles = [config.sops.templates."traefik.env".path];
    dynamicConfigFile = "${config.services.traefik.dataDir}/dynamic_config.yaml";
  };

  networking = {
    firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [
        443
        9987 # teamspeak
        5683 # HA
      ];
    };
  };

  environment.persistence."/persist".directories = lib.mkAfter [
    {
      directory = "/var/lib/traefik";
      user = "traefik";
      group = "traefik";
      mode = "u=rwx,g=rx,o=";
    }
  ];
}
