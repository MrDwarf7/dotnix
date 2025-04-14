{
  pkgs,
  lib,
  config,
  ...
}: let
in {
  options = {
    program.fishShell.enable = lib.mkEnableOption "Enable the Fish shell";
  };

  config = lib.mkIf config.program.fishShell.enable {
    users.users.dwarf.shell = pkgs.fish;
    users.users.root.shell = pkgs.fish;
    environment.systemPackages = with pkgs; [
      fish
      starship
      zoxide
    ];
  };
}
