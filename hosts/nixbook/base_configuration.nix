{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
  ];

  # basics (tz/locale)
  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05"; # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
}
