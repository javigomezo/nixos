{self, ...}: {
  flake.nixosModules.immich = {config, ...}: {
    imports = with self.nixosModules; [
      immichPostgres
      immichRedis
      immichMachineLearning
      immichServer
    ];

    sops = {
      secrets = {
        "immich/postgres_user" = {};
        "immich/postgres_password" = {};
        "immich/postgres_db" = {};
      };
      templates."immich.env" = {
        content = ''
          DB_DATABASE_NAME=${config.sops.placeholder."immich/postgres_db"}
          DB_USERNAME=${config.sops.placeholder."immich/postgres_user"}
          DB_PASSWORD=${config.sops.placeholder."immich/postgres_password"}
          POSTGRES_DB=${config.sops.placeholder."immich/postgres_db"}
          POSTGRES_USER=${config.sops.placeholder."immich/postgres_user"}
          POSTGRES_PASSWORD=${config.sops.placeholder."immich/postgres_password"}
        '';
      };
    };
  };
}
