{self, ...}: {
  flake.nixosModules.homeServices = {
    imports = with self.nixosModules; [
      bambuStudio
      esphome
      glance
      grafana
      homeAssistant
      immich
      influxdb
      koshelf
      loki
      paperless
    ];
  };
}
