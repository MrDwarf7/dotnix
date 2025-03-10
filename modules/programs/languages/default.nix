{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
in {
  imports = [
    ./go.nix
    ./lua.nix
    (import ./misc.nix {inherit config inputs lib pkgs;})
    ./node.nix
    ./python.nix
    (import ./rust.nix {inherit config inputs lib pkgs;})
  ];
}
