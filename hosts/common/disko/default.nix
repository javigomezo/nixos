{
  lib,
  config,
  ...
}: {
  options = {
    disko.enable = lib.mkEnableOption {
      description = "Enables disko";
      type = lib.bool;
    };
    disko.encryption = lib.mkEnableOption {
      description = "Enables FDE";
      type = lib.bool;
    };
    disko.device = lib.mkOption {
      description = "/dev/disk/by-id/...";
      type = lib.str;
    };
  };
  config = lib.mkIf config.disko.enable {
    disko.devices = {
      disk = {
        vda = {
          type = "disk";
          device = config.disko.device;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                priority = 1;
                name = "ESP";
                start = "1M";
                end = "1024M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              swap = {
                size = "8G";
                content = {
                  type = "swap";
                  randomEncryption = true;
                };
              };
              luks =
                if config.disko.encryption
                then ./fde.nix
                else ./unencrypted.nix;
            };
          };
        };
      };
    };
  };
}
