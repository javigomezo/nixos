{self, ...}: {
  flake.nixosModules.otherServices = {
    imports = with self.nixosModules; [
      obsidianLiveSync
      scrutiny
      teamSpeak
    ];
  };
}
