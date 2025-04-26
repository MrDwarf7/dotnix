{pkgs, ...}: let
  checkAttrValue = cat: maybeIndex: let
    defaultSelections =
      builtins.mapAttrs (
        name: value:
        # If it's a list, get the first item
          if builtins.isList value
          then 0
          # If it's an attr set, get the first item
          else builtins.head (builtins.attrValues value)
      )
      defaults;
  in (
    if maybeIndex == null
    then defaultSelections.${cat}
    else maybeIndex
  );

  # getProgram function: takes a category and optionally an index/key
  getProgram = fromCat: maybeIndex:
    with builtins;
    # For lists (e.g., terminal), get the attr set at the index and extract its value
      head (attrValues (elemAt defaults.${fromCat} (
        checkAttrValue fromCat maybeIndex
      )));

  defaults = {
    terminal = [
      {ghostty = "${pkgs.ghostty}/bin/ghostty";}
      {kitty = "${pkgs.kitty}/bin/kitty";}
      {alacritty = "${pkgs.alacritty}/bin/alacritty";}
    ];
    fileManager = [
      {nautilus = "${pkgs.nautilus}/bin/nautilus";}
      {thunar = "${pkgs.xfce.thunar}/bin/thunar";}
    ];
    browser = [
      {firefox = "${pkgs.firefox}/bin/firefox";}
      {chromium = "${pkgs.chromium}/bin/chromium";}
    ];
    rofi = [
      {rofi = "${pkgs.rofi-wayland}/bin/rofi";}
      # { rofi = # "${pkgs.rofi}/bin/rofi"; }
    ];
    locking = [
      {hyprlock = "${pkgs.hyprlock}/bin/hyprlock";}
      # { swaylock = "${pkgs.swaylock}/bin/swaylock"; }
    ];
    screenshot = [
      {grim = "${pkgs.grim}/bin/grim";}
      {slurp = "${pkgs.slurp}/bin/slurp";}
      # { scrot = "${pkgs.scrot}/bin/scrot"; }
    ];
    clipboard = [
      {copy = "${pkgs.wl-clipboard}/bin/wl-copy";}
      # { xclip = "${pkgs.xclip}/bin/xclip"; }
    ];
    hyprTools = [
      {hyprpaper = "${pkgs.hyprpaper}/bin/hyprpaper";}
      {hyprpicker = "${pkgs.hyprpicker}/bin/hyprpicker";}
      {hyprsunset = "${pkgs.hyprsunset}/bin/hyprsunset";}
    ];
    randomWall = [
      {randomWall = "${import ../../modules/derivations/random-wall.nix {inherit pkgs;}}/bin/random-wall";}
    ];
    utilityBarTools = [
      {pamixer = "${pkgs.pamixer}/bin/pamixer";}
      {brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";}
      {playerctl = "${pkgs.playerctl}/bin/playerctl";}
      {notify-send = "${pkgs.libnotify}/bin/notify-send";}
    ];
  };
in {
  defaults = defaults;
  getProgram = getProgram;
}
