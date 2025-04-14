{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    program.miscTools.enable = lib.mkEnableOption "Enable miscellaneous tools";
  };

  config = lib.mkIf config.program.miscTools.enable {
    environment.systemPackages = with pkgs; [
      pandoc
      zathura
      peaclock
      obsidian
    ];
  };
}
