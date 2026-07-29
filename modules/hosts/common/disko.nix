{inputs, ...}: {
  flake.nixosModules.disko = {
    lib,
    config,
    ...
  }: let
    cfg = config.my.disko;
    btrfsContent = {
      type = "btrfs";
      extraArgs = ["-f"];
      subvolumes = {
        "@" = {};
        "@/root" = {
          mountpoint = "/";
          mountOptions = ["compress-force=zstd" "noatime"];
        };
        "@/root-blank" = {};
        "@/home" = {
          mountpoint = "/home";
          mountOptions = ["compress-force=zstd"];
        };
        "@/nix" = {
          mountOptions = ["compress-force=zstd" "noatime"];
          mountpoint = "/nix";
        };
        "@/persist" = {
          mountOptions = ["compress-force=zstd" "noatime"];
          mountpoint = "/persist";
        };
        "@/machines" = {
          mountpoint = "/var/lib/machines";
          mountOptions = ["compress-force=zstd" "noatime"];
        };
        "@/portables" = {
          mountpoint = "/var/lib/portables";
          mountOptions = ["compress=zstd" "noatime"];
        };
        "@/log" = {
          mountpoint = "/var/log";
          mountOptions = ["compress-force=zstd" "noatime"];
        };
      };
    };
    rootPartition =
      if cfg.encryption
      then {
        size = "100%";
        content = {
          type = "luks";
          name = "crypted";
          settings.allowDiscards = true;
          content = btrfsContent;
        };
      }
      else {
        size = "100%";
        content = btrfsContent;
      };
  in {
    imports = [
      inputs.disko.nixosModules.disko
    ];
    options.my.disko = {
      enable = lib.mkEnableOption "Enables disko";
      encryption = lib.mkEnableOption "full-disk encryption (LUKS)";
      device = lib.mkOption {
        description = "/dev/disk/by-id/...";
        type = lib.types.str;
      };
    };
    config = lib.mkIf cfg.enable {
      disko.devices.disk.vda = {
        type = "disk";
        device = cfg.device;
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
            luks = rootPartition;
          };
        };
      };
    };
  };
}
