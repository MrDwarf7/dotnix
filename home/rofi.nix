{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    home.rofi.enable = lib.mkEnableOption "Enable rofi config";
  };
  config = lib.mkIf config.home.rofi.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      cycle = true;
      terminal = "${pkgs.ghostty}/bin/ghostty";
      # terminal = "${pkgs.ghostty}/bin/wezterm";
      theme = ../no_nix/rofi-theme.rasi;
      extraConfig = {
        modi = "run,drun,window";

        show-icons = true;
        drun-display-format = "{icon} {name}";
        location = 0;
        disable-history = false;
        hide-scrollbar = true;
        display-drun = "   Apps ";
        display-run = "   Run ";
        display-window = " 󰕰  Window";
        sidebar-mode = true;
      };
    };
  };
}
