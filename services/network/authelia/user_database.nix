{config, ...}: {
  sops.templates."authelia_users_database.yaml" = {
    owner = "authelia-main";
    content = ''
      users:
        ${config.sops.placeholder."authelia/username"}:
          password: ${config.sops.placeholder."authelia/password"}
          displayname: ${config.sops.placeholder."authelia/displayname"}
          email: ${config.sops.placeholder."authelia/email"}
          groups:
              - admins
              - dev
          disabled: false
    '';
  };
}
