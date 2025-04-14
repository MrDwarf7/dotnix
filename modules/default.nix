{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {

  # TODO: Move this later lol
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  imports = [
    (import ./programs {
      config = config;
      inputs = inputs;
      lib = lib;
      pkgs = pkgs;

      # inherit config inputs lib pkgs;
    })
    ./bootloader.nix
    ( import ./env-variables.nix { pkgs = pkgs; })
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
    ./ssh.nix
    ./xdg.nix
  ];
}
