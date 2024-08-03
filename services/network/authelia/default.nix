{config, ...}: {
  imports = [
    ./configuration.nix
    ./user_database.nix
  ];

  sops = {
    secrets = {
      "authelia/username" = {};
      "authelia/password" = {};
      "authelia/displayname" = {};
      "authelia/email" = {};
      "authelia/jwt_secret" = {
        owner = "authelia-main";
      };
      "authelia/session_secret" = {
        owner = "authelia-main";
      };
      "authelia/encryption_key" = {
        owner = "authelia-main";
      };
    };
  };

  services.authelia.instances.main = {
    enable = true;
    secrets = {
      jwtSecretFile = config.sops.secrets."authelia/jwt_secret".path;
      sessionSecretFile = config.sops.secrets."authelia/session_secret".path;
      storageEncryptionKeyFile = config.sops.secrets."authelia/encryption_key".path;
    };
    settingsFiles = [
      config.sops.templates."authelia_configuration.yaml".path
    ];
  };
}
