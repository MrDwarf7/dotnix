# Zoxide intergration
# vim binds etc.
# Maybe making a directory to sep. out in the same way the .config folder does?
{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    home.fishShell.enable = lib.mkEnableOption "Enable the Fish shell";
  };

  config = lib.mkIf config.home.fishShell.enable {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.direnv = {
      enable = true;
      # enableFishIntegration = true;
    };

    programs.fish = {
      enable = true;
      shellAliases = {
        l = "ls -lah";
        la = "ls -lah";
        cls = "clear";
        ca = "clear && ls -lah";
        gst = "git status";
        gf = "git fetch";

        g = "git";
        ga = "git add";
        gaa = "git add --all";
        gb = "git branch";
        gba = "git branch -a";
        gc = "git commit";
        gcb = "git checkout -b";
        gcl = "git clone --recursive";
        gcm = ''
        '';

        gpl = "git pull";
        gpla = "git pull --all";

        gd = "git diff";
        gfp = "git fetch --all && git pull";
        gp = "git push";
        gco = "git checkout";
        grv = "git remote -v";

        lg = "lazygit";
        nos = "nh os switch";
        nhs = "nh home switch";
        b = "bat";
        c = "cat";
        y = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
            yazi $argv --cwd-file="$tmp"
            if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
              builtin cd -- "$cwd"
            end
            rm -f -- "$tmp"
        '';
      };
      interactiveShellInit = ''
            if test -e /usr/sbin/starship
                /usr/sbin/starship init fish | source
                commandline -f repaint
            end
        fish_vi_key_bindings
      '';
    };

    # shellInit = {
    # };

    # shellInitLast = {
    # };
  };
}
