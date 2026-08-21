{self, ...}: {
  flake.nixosModules.homeServices = {
    imports = with self.nixosModules; [
      bambuStudio
      bambuddy
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
