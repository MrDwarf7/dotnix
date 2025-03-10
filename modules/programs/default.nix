{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./cli-fun.nix
    (import ./cli-min.nix {inherit pkgs config inputs lib;})
    ./cli-rand.nix
    ./cli-dev.nix

    ./desktop

    (import ./languages/default.nix {inherit pkgs config inputs lib;})
    # pkgs = pkgs;
    # config = config;
    # inputs = inputs;
    # lib = lib;
    # ./languages
    ./hypr.nix
    ./river.nix
    ./lsp.nix
    ./misc-tools.nix
    ./utils.nix
    # ./uwu.nix
    ./fish-shell.nix
  ];
}
