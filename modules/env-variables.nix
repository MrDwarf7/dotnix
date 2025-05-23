{pkgs ? import <nixpkgs> {}}: {
  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";
      SHELL = "fish";
      NH_FLAKE = "/home/dwarf/dotnix";
      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = "24";

      XDG_CONFIG_HOME = "/home/dwarf/.config";
      XDG_DATA_HOME = "/home/dwarf/.xdg/data";
      XDG_STATE_HOME = "/home/dwarf/.xdg/state";
      XDG_CACHE_HOME = "/home/dwarf/.xdg/cache";
      XDG_CACHE_LOCAL_HOME = "/home/dwarf/.xdg/local";
      DOT_DIR = "/home/dwarf/dotnix";
      # STARSHIP_CONFIG = "/home/dwarf/.config/starship.toml";

      # Locales xdg dirs
      XDG_DESKTOP_DIR = "$HOME/Desktop";
      XDG_DOWNLOAD_DIR = "$HOME/downloads";
      XDG_DOCUMENTS_DIR = "$HOME/documents";
      XDG_PICTURES_DIR = "$HOME/pictures";
      ########

      WZT_ANIM_FPS = "144";
      WZT_MAX_FPS = "144";
      WZT_GPU_FRONTEND = "WebGpu";
      WZT_GPU_POWER_PREF = "HighPerformance";
      CARAPACE_BRIDGES = "all";

      GCC_COLOR = "eror=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
    };
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      # DOTNET_ROOT = "${pkgs.dotnet-sdk}/share/dotnet";
    };
  };
}
