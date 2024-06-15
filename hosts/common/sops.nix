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
      []
      ++ (
        if config.my.impermanence.enable
        then ["/persist/etc/ssh/ssh_host_ed25519_key"]
        else ["/etc/ssh/ssh_host_ed25519_key"]
      );
  };
}
