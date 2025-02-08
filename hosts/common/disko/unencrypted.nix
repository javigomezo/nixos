{
  size = "100%";
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
}
