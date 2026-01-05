{
  config,
  lib,
  ...
}: {
  networking.firewall.interfaces.podman0.allowedTCPPorts = lib.mkAfter [5030];
  sops = {
    secrets = {
      "soulseek/user" = {};
      "soulseek/password" = {};
      "soulseek/api_key" = {};
    };
    templates."slskd.env" = {
      content = ''
        SLSKD_NO_AUTH=true
        SLSKD_SLSK_USERNAME=${config.sops.placeholder."soulseek/user"}
        SLSKD_SLSK_PASSWORD=${config.sops.placeholder."soulseek/password"}
        SLSKD_USERNAME=${config.sops.placeholder."soulseek/user"}
        SLSKD_PASSWORD=${config.sops.placeholder."soulseek/password"}
        SLSKD_API_KEY=${config.sops.placeholder."soulseek/api_key"}
        SLSKD_FILE_PERMISSION_MODE=0666
        SLSKD_UMASK=000
      '';
    };
  };
  services.slskd = {
    enable = true;
    environmentFile = config.sops.templates."slskd.env".path;
    domain = null;
    settings = {
      directories = {
        downloads = "/var/lib/slskd/downloads";
        incomplete = "/var/lib/slskd/incomplete";
      };
      shares.directories = ["/mnt/rclone/media/music"];
    };
  };

  environment.persistence."/persist".directories = lib.mkAfter [
    {
      directory = "/var/lib/slskd";
      user = "slskd";
      group = "slskd";
      mode = "u=rwx,g=rwx,o=rwx";
    }
    {
      directory = "/var/lib/slskd/downloads";
      user = "slskd";
      group = "slskd";
      mode = "u=rwx,g=rwx,o=rwx";
    }
    {
      directory = "/var/lib/slskd/incomplete";
      user = "slskd";
      group = "slskd";
      mode = "u=rwx,g=rwx,o=rwx";
    }
    {
      directory = "/var/lib/slskd/shares";
      user = "slskd";
      group = "slskd";
      mode = "u=rwx,g=rwx,o=rwx";
    }
    {
      directory = "/var/lib/slskd/data";
      user = "slskd";
      group = "slskd";
      mode = "u=rwx,g=rwx,o=rwx";
    }
  ];
}
