{
  disko.devices = {
    disk = {
      vdb = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_960_EVO_250GB_S3ESNX0JB10293D";
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
            root = {
              name = "root";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # Override existing partition
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = ["compress-force=zstd" "noatime"];
                  };
                  "/root-blank" = {
                    mountOptions = ["compress-force=zstd" "noatime"];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = ["compress-force=zstd"];
                  };
                  "/nix" = {
                    mountOptions = ["compress-force=zstd" "noatime"];
                    mountpoint = "/nix";
                  };
                  "/persist" = {
                    mountOptions = ["compress-force=zstd" "noatime"];
                    mountpoint = "/nix";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
