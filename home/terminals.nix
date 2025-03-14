{
  config,
  lib,
  ...
}: {
  options = {
    home.terminals.enable = lib.mkEnableOption "Enable the terminal module";
  };

  config = lib.mkIf config.home.terminals.enable {
    programs.kitty = {
      enable = true;
      font = {
        # name = "Mononoki Nerd Font Mono";
        name = "JetBrains Mono";
        size = 12;
      };
      settings = {
        enable_audio_bell = false;
        confirm_os_window_close = 0;
      };
      themeFile = "tokyo_night_night";
    };

    programs.ghostty = {
      enable = true;
      # TODO: Test these to see what they do
      installBatSyntax = true; # Was false
      installVimSyntax = true; # Was false
      settings = {
        window-decoration = false;
        confirm-close-surface = false;

        ###########
        ## Fonts ##
        ###########
        font-size = 13.0;
        font-family-bold = "JetBrains Mono ExtraBold";
        font-family-italic = "JetBrains Mono Italic";
        font-family-bold-italic = "JetBrains Mono ExtraBold Italic";

        #############
        ## Theming ##
        #############
        theme = "tokyonight_night";
      };
    };

    programs.wezterm = {
      enable = true;
    };
  };
}
