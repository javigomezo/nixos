{
  lib,
  config,
  ...
}: {
  sops = {
    secrets = {
      "soulseek/user" = {
        owner = "slskd";
      };
      "soulseek/password" = {
        owner = "slskd";
      };
      "soulseek/api_key" = {
        owner = "slskd";
      };
    };
    templates."soulseek.env" = {
      content = ''
        SLSKD_SLSK_USERNAME=${config.sops.placeholder."soulseek/user"}
        SLSKD_SLSK_PASSWORD=${config.sops.placeholder."soulseek/password"}
        SLSKD_USERNAME=${config.sops.placeholder."soulseek/user"}
        SLSKD_PASSWORD=${config.sops.placeholder."soulseek/password"}
        SLSKD_API_KEY=${config.sops.placeholder."soulseek/password"}
      '';
      owner = "slskd";
    };
  };
  networking.firewall.interfaces.podman0.allowedTCPPorts = lib.mkAfter [5030];
  services.slskd = {
    enable = true;
    domain = "";
    environmentFile = config.sops.templates."soulseek.env".path;
    settings = {
      shares.directories = [
        "/mnt/Qbittorrent/music"
      ];
    };
    # openFirewall = false;
  };
  environment.persistence."/persist".directories = lib.mkAfter [
    {
      directory = "/var/lib/slskd";
      user = "javier";
      group = "slskd";
      mode = "u=rwx,g=rx,o=";
    }
  ];
}
