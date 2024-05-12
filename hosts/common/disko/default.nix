{
  lib,
  config,
  ...
}: {
  options.my.disko = {
    enable = lib.mkEnableOption {
      description = "Enables disko";
      type = lib.types.bool;
    };
    encryption = lib.mkEnableOption {
      description = "Enables FDE";
      type = lib.types.bool;
    };
    device = lib.mkOption {
      description = "/dev/disk/by-id/...";
      type = lib.types.str;
    };
  };
  config = lib.mkIf config.my.disko.enable {
    disko.devices = {
      disk = {
        vda = {
          type = "disk";
          device = config.my.disko.device;
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
                if config.my.disko.encryption
                then ./fde.nix
                else ./unencrypted.nix;
            };
          };
        };
      };
    };
  };
}
