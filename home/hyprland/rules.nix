{
  windowrule = [
    # "float,^(galculator)$"
    # "float,^(qemu)$"

    ####################################
    ## AUTOMATIC WORKSPACE ASSIGNMENT ##
    ####################################

    "workspace 3,title:([zZ]ed[-\\.]?(.*))"

    # "workspace 5,^(Element)$"
    # "workspace 5,^(Signal)$"
    # "workspace 7,^(Postman)$"

    # "workspace 8,^(discord|armcord|webcord|vencord|vesktop)$"
    # "workspace 9,^(Spotify)$"
    "workspace 10,title:([oO]bsidian)"

    # "opacity 1.0 0.95,class:(\\.?)([zZ]ed[-\\.]?).*,title:(\\.?)([zZ]ed[-\\.]?).*"
  ];
  windowrulev2 = [
    ########################
    ## Picture in Picture ##
    ########################
    "float, class:^(org.pulseaudio.pavucontrol)"
    "float, class:^()$,title:^(Picture in picture)$"
    "float, class:^()$,title:^(Save File)$"
    "float, class:^()$,title:^(Open File)$"
    "float, class:^(LibreWolf)$,title:^(Picture-in-Picture)$"
    "float, class:^(blueman-manager)$"
    "float, class:^(xdg-desktop-portal-gtk|xdg-desktop-portal-kde|xdg-desktop-portal-hyprland)(.*)$"
    "float, class:^(polkit-gnome-authentication-agent-1|hyprpolkitagent|org.org.kde.polkit-kde-authentication-agent-1)(.*)$"
    "float, class:^(zenity)$"
    "float, class:^()$,title:^(Steam - Self Updater)$"

    "opacity 1.00, class:^(thunar|nemo|dolphin)$"
    # "opacity 1.00, class:^(discord|armcord|webcord|vencord|vesktop)$"
    "opacity 1.00, class:^(QQ|Telegram)$"
    "opacity 1.00, class:^(NetEase Cloud Music Gtk4)$"

    "opacity 1.00, class:^(zed-e)(.*)$"
    "opacity 1.00, class:^(code)(.*)$"

    "float, title:^(Picture-in-Picture)$"
    "size 960 540, title:^(Picture-in-Picture)$"
    "move 25%-, title:^(Picture-in-Picture)$"

    "float, title:^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$"
    "size 960 540, title:^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$"
    "move 25%-, title:^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$"

    "pin, title:^(danmufloat)$"
    "rounding 5, title:^(danmufloat|termfloat)$"
    "animation slide right, class:^(kitty|Alacritty|ghostty|Ghostty|wezterm|Wezterm)$"
    "noblur, class:^(org.mozilla.firefox)$"

    "bordersize 2, floating:1, onworkspace:w[fv1-10]"
    # "bordercolor #000000, floating:1, onworkspace:w[fv1-10]"
    "rounding 8, floating:1, onworkspace:w[fv1-10]"

    "bordersize 3, floating:0, onworkspace:w[1-10]"
    "rounding 4, floating:0, onworkspace:w[1-10]"

    # "float,title:^(Picture-in-Picture)$"
    "noinitialfocus,title:^(Picture-in-Picture)$"
    "pin,title:^(Picture-in-Picture)$"
    "keepaspectratio,title:^(Picture-in-Picture)$"

    "float,class:^(it.mijorus.smile)$"
    "suppressevent maximize, class:.*" # You'll probably like this.

    # .zed-editor-wra
    # "opacity 1.0 0.95,class:(\\.?)([zZ]ed[-\\.]?).*,title:(\\.?)([zZ]ed[-\\.]?).*"
  ];
}
