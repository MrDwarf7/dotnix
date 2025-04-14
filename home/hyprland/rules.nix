{
  windowrule = [
    # "float,^(galculator)$"
    # "float,^(qemu)$"

    ####################################
    ## AUTOMATIC WORKSPACE ASSIGNMENT ##
    ####################################

    # "workspace 5,^(Element)$"
    # "workspace 5,^(discord)$"
    # "workspace 5,^(Signal)$"
    # "workspace 7,^(Postman)$"
    # "workspace 9,^(Spotify)$"
    "workspace 10,title:([oO]bsidian)"
    "opacity 1.0 0.95,class:(\\.?)([zZ]ed[-\\.]?).*,title:(\\.?)([zZ]ed[-\\.]?).*"
  ];
  windowrulev2 = [
    ########################
    ## Picture in Picture ##
    ########################
    "float,title:^(Picture-in-Picture)$"
    "noinitialfocus,title:^(Picture-in-Picture)$"
    "pin,title:^(Picture-in-Picture)$"
    "keepaspectratio,title:^(Picture-in-Picture)$"

    "float,class:^(it.mijorus.smile)$"

    "suppressevent maximize, class:.*" # You'll probably like this.

    # .zed-editor-wra
    "opacity 1.0 0.95,class:(\\.?)([zZ]ed[-\\.]?).*,title:(\\.?)([zZ]ed[-\\.]?).*"
  ];
}
