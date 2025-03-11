# {inputs, ...}: {
#   imports = [
#     ./configuration.nix
#     ./hardware-configuration.nix
#     ./disk-config.nix
#     ./home.nix
#     ./moxide.nix
#     ./spicetify.nix
#   ];
# }
{pkgs, ...}: let
  colors = import ../../colors.nix;
  hex = colors.hex;
in {
  imports = [
    ../../home/default.nix # TODO: perhaps easier to pull in a different way?
  ];

  # Then we go through like we have in hosts/$USER/configuration.nix
  # and basically just tick off all the options we want to enable.

  home.fishShell.enable = true;
  home.git.enable = true;
  home.gtk.enable = true;
  home.homeManagerConfig.enable = true;

  home.hypridle.enable = true;
  home.hyprlock = {
    enable = true;
    background = ../../assets/lockscreen.png;
  };
  home.hyprpaper = {
    enable = true;
    # path = "/home/dwarf/Pictures/wallpapers/hyprpaper.png";
    # path = "../../assets/wallpaper/geometry.png";
    # path = "../../assets/wallpaper/ryo-vending.png";
    path = ../../assets/wallpaper/stripes.png;
  };
  home.hyprland.enable = true;
  home.moxide = import ./moxide.nix;
  home.river.enable = true;
  home.rofi.enable = true;
  # home.wrofi.enable = true;
  home.starship.enable = true;
  home.terminals.enable = true;
  home.tmux.enable = true;
  home.waybar.enable = true;
  home.zathura.enable = true;
  # home.zshShell.enable = true; ## Have to move it later
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    # enableFishIntegration = true; ### TODO: No idea why but I cannot turn this on because apparently it's already set???????
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # services.mpris-proxy.enable = true;

  ### Could copy fish-shell.nix as an example for basically most programs, here are some inline
  home.bat.enable = true;
  # home.yazi.enable = true;

  # programs.bat = {
  #   enable = true;
  #   config.theme = "tokyonight";
  #   themes = {
  #     tokyonight = {
  #       src = pkgs.fetchFromGitHub {
  #         owner = "folke";
  #         repo = "tokyonight.nvim";
  #         rev = "057ef5d260c1931f1dffd0f052c685dcd14100a3";
  #         sha256 = "sha256-1xZhQR1BhH2eqax0swlNtnPWIEUTxSOab6sQ3Fv9WQA=";
  #       };
  #       file = "extras/sublime/tokyonight_night.tmTheme";
  #     };
  #   };
  # };

  gtk.gtk3.bookmarks = [
    "file://home/dwarf/Documents"
    "file://home/dwarf/downloads"
    "file://home/dwarf/Pictures"
    "file://home/dwarf/Music"
    "file://home/dwarf/Videos"
  ];

  home.file.".peaclock/config".text = ''
    set seconds on
    style active-bg ${hex.pink}
    style date ${hex.pink}
  '';

  xdg.desktopEntries = {
    peaclock = {
      name = "Peaclock";
      genericName = "Clock";
      exec = "${pkgs.ghostty}/bin/ghostty -- command=\"${pkgs.peaclock}/bin/peakclock\"";
      terminal = false;
      categories = ["Applications"];
    };
  };
}
