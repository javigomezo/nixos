{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    sops
  ];
  sops = {
    gnupg.sshKeyPaths = [];
    age.sshKeyPaths =
      ["/home/javier/.ssh/id_ed25519"]
      ++ (
        if config.my.impermanence.enable
        then ["/persist/etc/ssh/ssh_host_ed25519_key"]
        else ["/etc/ssh/ssh_host_ed25519_key"]
      );
    defaultSopsFile = ../${config.networking.hostName}/secrets.yaml;
    defaultSopsFormat = "yaml";
  };
}
