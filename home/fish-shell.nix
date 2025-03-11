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
    programs.fish = {
      enable = true;
      shellAliases = {
        l = "ls -lah";
        la = "ls -lah";
        cls = "clear";
        ca = "clear && ls -lah";
        gst = "git status";
        gd = "git diff";
        gfp = "git fetch --all && git pull";
        lg = "lazygit";
        nos = "nh os switch";
        nhs = "nh home switch";
        y = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
            yazi $argv --cwd-file="$tmp"
            if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
              builtin cd -- "$cwd"
            end
            rm -f -- "$tmp"
        '';
      };
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
