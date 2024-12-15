{
  config,
  pkgs,
  ...
}: let
  ifExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  sops.secrets = {
    javier_password = {
      neededForUsers = true;
      sopsFile = ../../hosts/common/secrets.yaml;
      format = "yaml";
    };
  };

  users = {
    mutableUsers = false;
    users.javier = {
      isNormalUser = true;
      description = "Javier";
      uid = 1000;
      hashedPasswordFile = config.sops.secrets.javier_password.path;
      shell = pkgs.zsh;
      group = "javier";
      extraGroups = ["wheel"] ++ ifExist ["networkmanager" "docker" "podman" "video" "audio" "git" "gpio" "spi"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzu6WsnLgOJ4Oos1vf/+Fmwp714q/T4N+Qok93br0sK javier@workstation"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJvEayrTyaS9XyCb9bo7XCdmIqZrumLrAPOH8h7UEYm javier@nuc"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzu6WsnLgOJ4Oos1vf/+Fmwp714q/T4N+Qok93br0sK javier@nixos"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPoNfSHGFcHCJMtPXJrPBY7um8IWJsmLhMmPD2iW32IX javier@y520"
      ];
      packages = [pkgs.home-manager];
    };

    groups = {
      javier = {
        gid = 1000;
      };
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
