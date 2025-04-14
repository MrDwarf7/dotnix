{
  pkgs,
  ags,
}: let
  mainMod = "SUPER";
  mainModShift = "${mainMod} SHIFT";
  mainModCtrl = "${mainMod} CTRL";
  secondModAlt = "SUPER ALT";

  agsPath = "${ags.packages.${pkgs.system}.ags}/bin/ags";
  # makeDate = "${pkgs.coreutils}/bin/date +%Y-%m-%d_%H:%M:%S";

  rules = import ./rules.nix;

  defaultPrograms = import ./defaultPrograms.nix {inherit pkgs;};
  defaults = defaultPrograms.defaults;
  getProgram = defaultPrograms.getProgram;
in {
  bind = let
    screenshotNotify = pkgs.writeShellScriptBin "screenshot-notify" ''
      ACTION_VIEW="viewScreenshot"
      ${pkgs.libnotify}/bin/notify-send "File copied and saved" \
      	--app-name="Screenshot" \
      	--action=$ACTION_VIEW="View" |
      	while read -r action; do
      		if [[ "$action" == $ACTION_VIEW ]]; then
      			xdg-open ~/pictures/screenshot.png
      		fi
      	done
    '';
  in [
    "${secondModAlt}, h, changegroupactive, b"
    "${secondModAlt}, l, changegroupactive, b"
    "${secondModAlt}, left, changegroupactive, b"
    "${secondModAlt}, right, changegroupactive, f"

    # Executables
    # "${mainMod}, Return, exec, ${pkgs.ghostty}/bin/ghostty"
    "${mainMod}, Return, exec, ${getProgram "terminal" null} " # ghostty
    "${mainModShift}, Return, exec, ${getProgram "terminal" 1} " # kitty
    "${mainMod}, R, exec, ${getProgram "rofi" null} -show drun" # rofi
    "${mainMod}, W, exec, ${getProgram "browser" null} " # firefox
    "${mainModShift}, W, exec, ${getProgram "browser" 1} " # chromium
    "${mainMod}, E, exec, ${getProgram "fileManager" null} " # nautilus
    "${mainModShift}, E, exec, ${getProgram "fileManager" 1} " # thunar

    "${mainMod}, U, exec, ${getProgram "locking" null} " # hyprlock
    "${mainModShift}, U, exec, ${agsPath} toggle power"
    "${mainModShift}, C, exec, ${getProgram "hyprTools" 1} | ${getProgram "clipboard" null}"

    "${mainMod}, ., exec, ${pkgs.smile}/bin/smile"

    "${mainMod}, Y, exec, ${agsPath} toggle controll-center"
    "${mainModShift}, Y, exec, ${agsPath} toggle bar"
    "${mainMod}, F8, exec, ${getProgram "rofi" null} -show run" # rofi
    "${mainMod}, F9, exec, ${getProgram "rofi" null} -show window" # rofi
    "${mainMod}, F10, exec, ${getProgram "randomWall" null}"

    # Hyprland Utility
    ## screenshot
    "${mainModShift}, S, exec, ${getProgram "screenshot" null} -g \"$(${getProgram "screenshot" 1})\" ~/Pictures/screenshot.png && cat ~/Pictures/screenshot.png | ${getProgram "clipboard" null} && ${screenshotNotify}/bin/screenshot-notify"
    "${mainMod}, S, exec, ${getProgram "screenshot" null} ~/Pictures/screenshot.png && cat ~/Pictures/screenshot.png | ${pkgs.wl-clipboard}/bin/wl-copy && ${screenshotNotify}/bin/screenshot-notify"
    "${mainMod}, F, togglefloating"
    "${mainMod}, C, centerwindow"
    "${mainMod}, Space, togglesplit,"
    "${mainMod}, P, pin"
    "${mainModShift}, G, lockgroups, toggle"
    "${mainMod}, G, togglegroup"
    "${mainMod}, Q, killactive,"

    # "${mainMod}, F, fullscreen, 1"
    # "${mainMod} SHIFt, F, fullscreen, 0"

    #### Arrows used for workspace stuff ####
    #### Letters used for in the current viewport/workspace ####

    # Move current focus
    "${mainMod}, h, movefocus, l"
    "${mainMod}, j, movefocus, d"
    "${mainMod}, k, movefocus, u"
    "${mainMod}, l, movefocus, r"

    # Move it around on the current screen
    "${mainModShift}, h, movewindow, l"
    "${mainModShift}, j, movewindow, d"
    "${mainModShift}, k, movewindow, u"
    "${mainModShift}, l, movewindow, r"

    # Relative
    ## Move view to a workspace
    "${mainMod}, left, workspace, e-1"
    "${mainMod}, down, workspace, e-1"
    "${mainMod}, up, workspace, e+1"
    "${mainMod}, right, workspace, e+1"

    # Absolute
    ## Move view to a workspace - number keys
    "${mainMod}, 1, workspace, 1"
    "${mainMod}, 2, workspace, 2"
    "${mainMod}, 3, workspace, 3"
    "${mainMod}, 4, workspace, 4"
    "${mainMod}, 5, workspace, 5"
    "${mainMod}, 6, workspace, 6"
    "${mainMod}, 7, workspace, 7"
    "${mainMod}, 8, workspace, 8"
    "${mainMod}, 9, workspace, 9"
    "${mainMod}, 0, workspace, 10"

    # Relative
    ## Move window to workspace
    "${mainModShift}, left, movetoworkspace, e-1"
    "${mainModShift}, down, movetoworkspace, e-1"
    "${mainModShift}, up, movetoworkspace, e+1"
    "${mainModShift}, right, movetoworkspace, e+1"

    "${mainMod}, mouse_down, workspace, e+1"
    "${mainMod}, mouse_up, workspace, e-1"

    # Absolute - number keys
    "${mainModShift}, 1, movetoworkspace, 1"
    "${mainModShift}, 2, movetoworkspace, 2"
    "${mainModShift}, 3, movetoworkspace, 3"
    "${mainModShift}, 4, movetoworkspace, 4"
    "${mainModShift}, 5, movetoworkspace, 5"
    "${mainModShift}, 6, movetoworkspace, 6"
    "${mainModShift}, 7, movetoworkspace, 7"
    "${mainModShift}, 8, movetoworkspace, 8"
    "${mainModShift}, 9, movetoworkspace, 9"
    "${mainModShift}, 0, movetoworkspace, 10"

    "${mainMod}, Tab, workspace, next"
    "${mainModShift}, Tab, workspace, previous"
  ];

  binde = [
    "${mainModCtrl}, h, resizeactive, -10 0"
    "${mainModCtrl}, j, resizeactive, 0 10"
    "${mainModCtrl}, k, resizeactive, 0 -10"
    "${mainModCtrl}, l, resizeactive, 10 0"
  ];

  bindm = [
    "${mainMod}, mouse:272, movewindow"
    "${mainMod}, mouse:273, resizewindow"
  ];

  bindel = [
    ", XF86AudioLowerVolume, exec, ${getProgram "utilityBarTools" null} -d 2"
    ", XF86AudioRaiseVolume, exec, ${getProgram "utilityBarTools" null} -i 2"
    ", XF86MonBrightnessUp, exec, ${getProgram "utilityBarTools" 1} set +5%"
    ", XF86MonBrightnessDown, exec, ${getProgram "utilityBarTools" 1} set 5%-"
  ];

  bindl = [
    ", XF86AudioMute, exec, ${getProgram "utilityBarTools" null} -t"
    "${mainMod}, M, exec, ${getProgram "utilityBarTools" 2} --player=spotify play-pause"
  ];

  windowrulev2 = rules.windowrulev2;
  windowrule = rules.windowrule;
}
