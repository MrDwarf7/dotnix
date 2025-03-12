{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    program.river.enable = lib.mkEnableOption "Enable the River window manager";
  };

  config = lib.mkIf config.program.river.enable {
    environment.systemPackages = with pkgs; [
      river
      glib
      wl-clipboard
      grim
      slurp
      rofi-wayland
      swaylock
      hyprpaper
    ];

    # Hyprland REQUIRED or else kitty won't start on river
    programs.hyprland.enable = true;
    services.gvfs.enable = true;
  };
}
