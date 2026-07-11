{lib, ...}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings = {
      # gui.insecureSkipHostcheck = true;
      devices.kindle = {
        id = "NPNF4EC-ITB4BRE-OMTDQLY-Y426DZE-JLKSBR4-H6A6GMQ-ILYITNT-5CO3TQP";
        name = "kindle";
      };
      folders = {
        koreader_database = {
          enable = true;
          devices = ["kindle"];
          path = "/var/lib/syncthing/koreader/database";
          label = "database";
        };
        libros = {
          enable = true;
          devices = ["kindle"];
          path = "/var/lib/syncthing/koreader/libros";
          label = "libros";
        };
      };
    };
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
