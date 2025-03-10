# {inputs, ...}: {
#   imports = [
#     ./configuration.nix
#     ./hardware-configuration.nix
#     ./disk-config.nix
#     ./home.nix
#     ./moxide.nix
#     ./spicetify.nix
#   ];
# }
{pkgs, ...}: let
  colors = import ../../colors.nix;
  hex = colors.hex;
in {
  imports = [
    ../../home # TODO: perhaps easier to pull in a different way?
  ];

  # Then we go through like we have in hosts/$USER/configuration.nix
  # and basically just tick off all the options we want to enable.

  home.git.enable = true;
  home.gtk.enable = true;
  home.homeManagerConfig.enable = true;
}
