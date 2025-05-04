{lib, ...}: {
  services.audiobookshelf = {
    enable = true;
    openFirewall = false;
  };
  environment.persistence."/persist".directories = lib.mkAfter [
    {
      directory = "/var/lib/audiobookshelf";
      user = "audiobookshelf";
      group = "audiobookshelf";
      mode = "u=rwx,g=rx,o=";
    }
  ];
}
