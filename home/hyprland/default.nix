{
  pkgs,
  config,
  lib,
  ags,
  ...
}: let
  allColors = import ../../colors.nix;
  colors = allColors.hypr;
  shellName = "tokyo-shell";
  myShell = ags.lib.bundle {
    inherit pkgs;
    extraPackages =
      (with ags.packages.${pkgs.system}; [
        hyprland
        mpris
        battery
        wireplumber
        network
        bluetooth
        powerprofiles
        notifd
        apps
      ])
      ++ (with pkgs; [
        hyprpicker
        hyprsunset
        slurp
        grim
        brightnessctl
        libnotify
        wlinhibit
        wl-clipboard
        libnotify
      ]);
    src = ../../no_nix/ags;
    name = shellName;
    entry = "app.ts";
    gtk4 = false;
  };
in {
  options = {
    home.hyprland.enable = lib.mkEnableOption "Enable hyprland config";
  };
  config = with config.home;
    lib.mkIf hyprland.enable {
      wayland.windowManager.hyprland = let
        accent = colors.pink;
        inactive = colors.base;
        shadow = colors.crust;
        bind = import ./bind.nix {inherit pkgs ags;};
        rules = import ./rules.nix;
      in {
        enable = true;
        # plugins = [pkgs.hyprlandPlugins.hyprgrass];
        settings = {
          plugins = {};

          # TODO: Have to figure out what the actual one is
          monitor = ["eDP-1,2560x1600,0x0,1.33"];
          exec-once = [
            "${myShell}/bin/${shellName}"
            "${pkgs.hyprpaper}/bin/hyprpaper"
            "${pkgs.wvkbd}/bin/wvkbd-mobintl --hidden -L 300"
            # "${pkgs.hyprland}/bin/hyprland"
            # "${pkgs.waybar}/bin/waybar"
          ];
          general = {
            gaps_in = 5;
            gaps_out = 8;
            border_size = 1;
            "col.active_border" = accent;
            "col.inactive_border" = inactive;
            resize_on_border = true;
            allow_tearing = false;
            layout = "dwindle";
          };
          decoration = {
            rounding = 3;
            active_opacity = 0.9;
            inactive_opacity = 0.8;
            shadow = {
              range = 100;
              render_power = 1;
              scale = 0.9;
              color = shadow;
            };
          };
          animations = {
            enabled = false;
            bezier = "shot, 0.2, 1.0, 0.2, 1.0";
            animation = [
              "windows, 1, 4, shot, slide"
              "workspaces, 1, 4, shot"
            ];
          };
          input = {
            kb_layout = "us";
            kb_options = "caps:escape";
            #kb_variant = "colemark";
            kb_model = "";
            kb_rules = "";
            sensitivity = 0;
            accel_profile = "flat";
            # force_no_accel = true; ## Can cause hardware->software mouse desync
            follow_mouse = 2; # 0 = disabled, 1 = cursor- always change to window under curosr, 2 = cursor - cursor & keyboard are 'sep'. clicking will move keyboard always, 3 = cursor focus is ENTIRELY sep. from keyboard - window clicks don't move keyboard
            # follow_mouse_threshold = 1;
            focus_on_close = 0; # 0 = focus to next window candidate, 1 = focus to window under cursor
            repeat_rate = 55; # Repeat rate of the keypress being taken
            repeat_delay = 300; # Delay before the keypress starts repeating

            touchpad = {
              disable_while_typing = true;
              natural_scroll = true;
              tap-to-click = false;
            };
          };
          gestures = {
            workspace_swipe = true;
            workspace_swipe_fingers = 3;
            workspace_swipe_distance = 200;
            workspace_swipe_direction_lock_threshold = 10; # in px, the distance to swipe before direction lock activates (touchpad only).
          };
          group = {
            "col.border_active" = accent;
            "col.border_inactive" = inactive;
            groupbar = {
              enabled = true;
              "col.active" = accent;
              "col.inactive" = inactive;
              text_color = colors.text;
            };
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true; ## splash???????
            force_default_wallpaper = -1;
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
            force_split = 2;
          };

          bind = bind.bind;
          binde = bind.binde;
          bindm = bind.bindm;
          bindel = bind.bindel;
          bindl = bind.bindl;

          windowrule = rules.windowrule;
          windowrulev2 = rules.windowrulev2;
        };
      };
    };
}
