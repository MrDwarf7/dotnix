# Step 1: Run lsblk and find the device name of your disk
# Step 2: cd /tmp
# Step 3: curl https://raw.githubusercontent.com/mrdwarf7/dotnix/main/main/hosts/nixbook/disk-config.nix > /tmp/disk-config.nix
# Step 4: EDIT THE EXISTING CONFIG AND CHECK
# Step 5: sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/disk-config.nix
# (NOTE: the arg for --dry-run OR --yes-wipe-all-disks)
#
# Step 6: nixos-generate-config --no-filesystem --root /mnt
# Step 7 (Optional now really, though safer lol): mv /tmp/disk-config.nix /mnt/etc/nixos
# Step SANITY - Check to make sure the new disk is included in the flake.nix config somwhere and the attrs are set up correctly
#

let
  attrs = [
    "compress=zstd"
    "noatime"
    "ssd"
    "discard=async"
    "space_cache=v2"
  ];

  device = "/dev/sda";
in {
  # Disko can manage multiple devices; we’ll just define one called "disk"
  # that points to /dev/sda. Adjust "device" as needed (e.g. /dev/nvme0n1).
  disko.devices = {
    disk.main = {
      type = "disk";
      device = device;

      content = {
        type = "gpt";
        # Two partitions: EFI (name: ESP) + Btrfs (name: root)
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
              # use
              extraArgs = ["-f"];

              # By default, disko will mount the top-level
              # partition somewhere (unless you remove mountpoint),
              # but we can keep a neutral placeholder mountpoint:
              # mountpoint = "/partition-root";

              # Our subvolumes:
              subvolumes = {
                # Root subvolume
                "/rootfs" = {
                  mountpoint = "/";
                  mountOptions = attrs;
                };

                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = attrs;
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = attrs;
                };

                # "/home/dwarf" = {};

                # "/var" = {
                #   mountpoint = "/var";
                #   mountOptions = attrs;
                # };

                "/var-log" = {
                  mountpoint = "/var/log";
                  mountOptions = attrs;
                };

                "/var-machines" = {
                  mountpoint = "/var/machines";
                  mountOptions = attrs;
                };

                "/snapshots" = {
                  mountpoint = "/snapshots";
                  mountOptions = attrs;
                };

                "/swap" = {
                  mountpoint = "/.swapvol";
                  mountOptions = attrs;

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
              mountpoint = "/partition-root";
              swap = {
                swapfile = {
                  size = "20M";
                };
                # swapfile1 = {
                #   size = "20M";
                # };
              };
            };
          };
        };
      };
    };
  };
}
