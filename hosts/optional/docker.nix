{lib, ...}: {
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    storageDriver = "btrfs";
  };
  systemd.services.docker.after = lib.mkForce ["network.target" "docker.socket" "graphical.target"];
}
