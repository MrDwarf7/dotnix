{...}: let
  attrs = [
    "compress=zstd"
    "noatime"
    "ssd"
    "discard=async"
    "space_cache=v2"
  ];
in {
  # Disko can manage multiple devices; we’ll just define one called "disk"
  # that points to /dev/sda. Adjust "device" as needed (e.g. /dev/nvme0n1).
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/sda";

      content = {
        type = "gpt";
        # Two partitions: EFI + Btrfs
        partitions = {
          ESP = {
            # ~1 GiB for EFI
            name = "ESP";
            start = "1M"; # optional
            end = "1G"; # optional
            type = "EF00"; # EFI partition
            content = {
              type = "filesystem";
              format = "vfat";
              # All mount options can go in NixOS config,
              # but disko supports them as well:
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };

          root = {
            size = "100%";
            name = "root";
            # Btrfs partition that will contain our subvolumes
            content = {
              type = "btrfs";

              # If the disk was previously formatted, you can
              # use extraArgs to forcibly reformat:
              # extraArgs = ["-f"];

              # By default, disko will mount the top-level
              # partition somewhere (unless you remove mountpoint),
              # but we can keep a neutral placeholder mountpoint:
              mountpoint = "/partition-root";

              # Our subvolumes:
              subvolumes = {
                # Root subvolume
                "/" = {
                  mountpoint = "/";
                  mountOptions = attrs;
                  # = [
                  #   "compress=zstd"
                  #   "noatime"
                  #   "ssd"
                  #   "discard=async"
                  #   "space_cache=v2"
                  # ];

                  extraArgs = ["-L root"];
                };

                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = attrs;

                  extraArgs = ["-L nix"];
                };

                "/home" = {
                  mountpoint = "/home";
                  mountOptions = attrs;

                  extraArgs = ["-L home"];
                };

                "/var-log" = {
                  mountpoint = "/var/log";
                  mountOptions = attrs;

                  extraArgs = ["-L var-log"];
                };

                "/var-machines" = {
                  mountpoint = "/var/machines";
                  mountOptions = attrs;
                  extraArgs = ["-L var-machines"];
                };

                "/snapshots" = {
                  mountpoint = "/snapshots";
                  mountOptions = attrs;
                  extraArgs = ["-L snapshots"];
                };

                "/swap" = {
                  mountpoint = "/swap";
                  mountOptions = attrs;
                  extraArgs = ["-L swap"];

                  # Create a swap file automatically in this subvolume
                  swap = {
                    # Named "swapfile" by default, size 4GiB
                    swapfile = {
                      size = "4G";
                    };
                  };
                };
              };

              # Alternatively you can define top-level "swap = {...}" here
              # for a partition-wide swapfile, but we put it in /@swap above.
            };
          };
        };
      };
    };
  };
}
