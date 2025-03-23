{
  lib,
  config,
  ...
}: {
  sops = {
    secrets = {
      "glance/tw_1" = {};
      "glance/tw_2" = {};
      "glance/tw_3" = {};
      "glance/tw_4" = {};
      "glance/tw_5" = {};
      "glance/tw_6" = {};
      "glance/yt_1" = {};
      "glance/yt_2" = {};
      "glance/yt_3" = {};
      "glance/yt_4" = {};
      "glance/yt_5" = {};
      "glance/yt_6" = {};
      "glance/rdt_1" = {};
      "glance/rdt_2" = {};
      "glance/rdt_3" = {};
      "glance/rdt_4" = {};
      "glance/rdt_5" = {};
      "glance/rdt_6" = {};
    };
    templates."glance.env" = {
      content = ''
        TW_1 = ${config.sops.placeholder."glance/tw_1"}
        TW_2 = ${config.sops.placeholder."glance/tw_2"}
        TW_3 = ${config.sops.placeholder."glance/tw_3"}
        TW_4 = ${config.sops.placeholder."glance/tw_4"}
        TW_5 = ${config.sops.placeholder."glance/tw_5"}
        TW_6 = ${config.sops.placeholder."glance/tw_6"}
        YT_1 = ${config.sops.placeholder."glance/yt_1"}
        YT_2 = ${config.sops.placeholder."glance/yt_2"}
        YT_3 = ${config.sops.placeholder."glance/yt_3"}
        YT_4 = ${config.sops.placeholder."glance/yt_4"}
        YT_5 = ${config.sops.placeholder."glance/yt_5"}
        YT_6 = ${config.sops.placeholder."glance/yt_6"}
        RDT_1 = ${config.sops.placeholder."glance/rdt_1"}
        RDT_2 = ${config.sops.placeholder."glance/rdt_2"}
        RDT_3 = ${config.sops.placeholder."glance/rdt_3"}
        RDT_4 = ${config.sops.placeholder."glance/rdt_4"}
        RDT_5 = ${config.sops.placeholder."glance/rdt_5"}
        RDT_6 = ${config.sops.placeholder."glance/rdt_6"}
      '';
    };
  };
  services.glance = {
    enable = true;
    settings = {
      server = {
        port = 3333;
      };
      theme = {
        background-color = "229 19 23";
        contrast-multiplier = 1.2;
        primary-color = "222 74 74";
        positive-color = "96 44 68";
        negative-color = "359 68 71";
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
                  channels = [
                    "\${TW_1}"
                    "\${TW_2}"
                    "\${TW_3}"
                    "\${TW_4}"
                    "\${TW_5}"
                    "\${TW_6}"
                  ];
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
                  widgets = [
                    {
                      type = "reddit";
                      subreddit = "\${RDT_1}";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "\${RDT_2}";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "\${RDT_3}";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "\${RDT_4}";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "\${RDT_5}";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "\${RDT_6}";
                      show-thumbnails = true;
                    }
                  ];
                }
                {
                  type = "videos";
                  channels = [
                    "\${YT_1}"
                    "\${YT_2}"
                    "\${YT_3}"
                    "\${YT_4}"
                    "\${YT_5}"
                    "\${YT_6}"
                  ];
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
    serviceConfig.ProcSubset = lib.mkForce "all";
  };
}
