{
  lib,
  config,
  ...
}: let
  ytSecretsCount = 7;
  twSecretsCount = 6;
  rdtSecretsCount = 6;
  generateSecrets = prefix: count:
    builtins.listToAttrs (map
      (
        i: {
          name = "glance/${prefix}_${toString i}";
          value = {};
        }
      ) (builtins.genList (x: x + 1) count));

  generatePlaceholders = prefix: count:
    builtins.concatStringsSep "\n" (map
      (
        i: "${lib.toUpper prefix}_${toString i} = ${config.sops.placeholder."glance/${prefix}_${toString i}"}"
      ) (builtins.genList (x: x + 1) count));

  generateChannelList = prefix: count:
    map (i: "\${${prefix}_${toString i}}") (builtins.genList (x: x + 1) count);

  generateRedditWidgets = count:
    map (i: {
      type = "reddit";
      subreddit = "\${RDT_${toString i}}";
      show-thumbnails = true;
    }) (builtins.genList (x: x + 1) count);

  twSecrets = generateSecrets "tw" twSecretsCount;
  ytSecrets = generateSecrets "yt" ytSecretsCount;
  rdtSecrets = generateSecrets "rdt" rdtSecretsCount;

  twPlaceholders = generatePlaceholders "tw" twSecretsCount;
  ytPlaceholders = generatePlaceholders "yt" ytSecretsCount;
  rdtPlaceholders = generatePlaceholders "rdt" rdtSecretsCount;
in {
  sops = {
    secrets = twSecrets // ytSecrets // rdtSecrets;
    templates."glance.env" = {
      content = ''
        ${twPlaceholders}
        ${ytPlaceholders}
        ${rdtPlaceholders}
      '';
    };
  };
  services.glance = {
    enable = true;
    settings = {
      server = {
        host = "0.0.0.0";
        port = 3333;
      };
      pages = [
        {
          name = "Inicio";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "calendar";
                  first-day-of-week = "monday";
                }
                {
                  type = "twitch-channels";
                  sort-by = "live";
                  channels = generateChannelList "TW" twSecretsCount;
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "search";
                  search-engine = "duckduckgo";
                  autofocus = true;
                }
                {
                  type = "group";
                  widgets = generateRedditWidgets rdtSecretsCount;
                }
                {
                  type = "videos";
                  channels = generateChannelList "YT" ytSecretsCount;
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  location = "Santander, Spain";
                  units = "metric";
                  hour-format = "24h";
                }
                {
                  type = "server-stats";
                  servers = [
                    {
                      type = "local";
                      name = "Nuc8i3BEH";
                    }
                  ];
                }
                {
                  type = "docker-containers";
                  sock-path = "/run/podman/podman.sock";
                }
              ];
            }
          ];
        }
      ];
    };
  };
  systemd.services.glance = {
    serviceConfig.EnvironmentFile = [config.sops.templates."glance.env".path];
    serviceConfig.Group = "podman";
  };
}
