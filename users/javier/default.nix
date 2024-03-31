{
  config,
  pkgs,
  ...
}: let
  ifExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  # age.identityPaths = ["/home/javier/.ssh/id_ed25519"];
  age.secrets.hashedUserPassword = {
    file = ../../secrets/hashedUserPassword.age;
  };

  users.users.javier = {
    isNormalUser = true;
    description = "Javier";
    uid = 1000;
    hashedPasswordFile = config.age.secrets.hashedUserPassword.path;
    shell = pkgs.zsh;
    group = "javier";
    extraGroups = ["wheel"] ++ ifExist ["networkmanager" "docker" "podman" "video" "audio" "git" "gpio" "spi"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzu6WsnLgOJ4Oos1vf/+Fmwp714q/T4N+Qok93br0sK javier@workstation"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJvEayrTyaS9XyCb9bo7XCdmIqZrumLrAPOH8h7UEYm javier@nuc"
    ];
    packages = [pkgs.home-manager];
  };

  users.groups = {
    javier = {
      gid = 1000;
    };
  };

  security.sudo.extraRules = [
    {
      users = ["javier"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  programs.zsh.enable = true;
}
