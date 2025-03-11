{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    home.bat.enable = lib.mkEnableOption "Enable the bat syntax highlighter";
  };

  config = lib.mkIf config.home.bat.enable {
    programs.bat = {
      enable = true;
      config.theme = "Monokai Extended Bright";
      # themes = {
      #   tokyonight = {
      #     src = pkgs.fetchFromGitHub {
      #       owner = "folke";
      #       repo = "tokyonight.nvim";
      #       rev = "057ef5d260c1931f1dffd0f052c685dcd14100a3";
      #       sha256 = "sha256-1xZhQR1BhH2eqax0swlNtnPWIEUTxSOab6sQ3Fv9WQA=";
      #     };
      #     file = "extras/sublime/tokyonight_night.tmTheme";
      #   };
      # };
    };
  };
}
