{
  config,
  lib,
  ...
}: {
  options = {
    home.homeManagerConfig.enable = lib.mkEnableOption "Enable homemanager";
  };

  config = lib.mkIf config.home.homeManagerConfig.enable {
    home.username = "dwarf";
    home.homeDirectory = "/home/dwarf";

    home.stateVersion = "25.05"; # Dont'change

    programs.home-manager.enable = true;
  };
}
