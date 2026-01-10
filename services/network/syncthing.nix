{lib, ...}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings.gui.insecureSkipHostcheck = true;
  };
  environment.persistence."/persist".directories = lib.mkAfter [
    {
      directory = "/var/lib/syncthing";
      user = "syncthing";
      group = "syncthing";
      mode = "u=rwx,g=rx,o=";
    }
  ];
}
