# Zoxide intergration
# vim binds etc.
# Maybe making a directory to sep. out in the same way the .config folder does?
{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    home.fishShell.enable = lib.mkEnableOption "Enable the Fish shell";
  };

  config = lib.mkIf config.home.fishShell.enable {
    programs.fish = {
      enable = true;
      shellAliases = {
        l = "ls -lah";
        la = "ls -lah";
        cls = "clear";
        ca = "clear && ls -lah";
      };
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
