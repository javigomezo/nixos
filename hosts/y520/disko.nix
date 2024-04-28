{
  disko.devices = {
    disk = {
      vda = {
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
            swap = {
              size = "8G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"]; # Override existing partition
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
              };
            };
          };
        };
      };
    };
  };
}
