{...}: {
  imports = [
  ];

  # Bootloader stuff
  boot.loader.systemd-boot.enable = true; # enables systemd-boot
  boot.loader.efi.canTouchEfiVariables = true; # allows systemd-boot to touch EFI variables - ie: install a boot loader or entry
  boot.loader.timeout = 5; # sets the timeout to 5 seconds, systemd-boot supports using < null > for instant unless holding a key
}
