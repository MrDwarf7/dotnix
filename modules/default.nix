{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    (import ./programs {
      config = config;
      inputs = inputs;
      lib = lib;
      pkgs = pkgs;

      # inherit config inputs lib pkgs;
    })
    ./bootloader.nix
    ./env-variables.nix
    ./firewall.nix
    ./fonts.nix
    ./locale.nix
    ./network.nix
    ./nix_os.nix
    ./power-off.nix
    (import ./sops-secret.nix {
      pkgs = pkgs;
      lib = lib;
      config = config;
      inputs = inputs;
    })
    ./xdg.nix
  ];
}
