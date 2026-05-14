{lib, ...}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings.gui.insecureSkipHostcheck = true;
    configDir = "/var/lib/syncthing/config";
  };
  environment.persistence."/persist".directories = lib.mkAfter [
    {
      directory = "/var/lib/syncthing";
      user = "syncthing";
      group = "syncthing";
      mode = "u=rwx,g=rx,o=";
    }
    {
      directory = "/var/lib/syncthing/config";
      user = "syncthing";
      group = "syncthing";
      mode = "u=rwx,g=rx,o=";
    }
  ];
}
