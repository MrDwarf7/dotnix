{
  config,
  lib,
  # pkgs,
  ...
}: {
  options = {
    home.btop.enable = lib.mkEnableOption "Enable the btop system monitor";
  };

  config = lib.mkIf config.home.btop.enable {
    programs.btop = {
      enable = true;
    };
  };
}
