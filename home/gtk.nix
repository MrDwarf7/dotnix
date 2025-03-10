{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    home.gtk.enable = lib.mkEnableOption "Enable gtk config";
  };
  config = lib.mkIf config.home.gtk.enable {
    gtk = {
      enable = true;
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
      theme = {
        package = pkgs.tokyonight-gtk-theme.override {
          colorVariants = ["dark"];
          themeVariants = ["pink"];
          tweakVariants = ["macos"];
        };
        name = "Tokyonight-Pink-Dark";
        # package = pkgs.catppuccin-gtk;
        # name = "catppuccin-frappe-blue-standard";
        # name = "catppuccin-latte-blue-standard";
      };
      iconTheme = {
        # package = pkgs.fluent-icon-theme;
        # name = "Fluent-dark";
        # name = "WhiteSur-dark";
        # package = pkgs.whitesur-icon-theme;
        name = "Dracula";
        package = pkgs.dracula-icon-theme;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
  };
}
