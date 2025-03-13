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
        ef = "exec fish";
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
      };
      interactiveShellInit = ''
            if test -e starship; and test -x starship
                starship init fish | source
                commandline -f repaint
            end
        fish_vi_key_bindings
      '';

      functions = {
        md = {
          body = ''
            mkdir -p $argv
          '';
        };
        y = {
          body = ''
            set tmp (mktemp -t "yazi-cwd.XXXXXX")
              yazi $argv --cwd-file="$tmp"
              if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
                builtin cd -- "$cwd"
              end
              rm -f -- "$tmp"
          '';
        };

        fish_user_key_bindings = {
          body = ''
            set -x fish_sequence_key_delay_ms 160

            bind -M default H beginning-of-line
            bind -M default L end-of-line

            bind -M visual H beginning-of-line
            bind -M visual L end-of-line

            bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint; end"
            bind -M insert jj "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint; end"
            bind -M insert kj "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint; end"
            bind -M insert kk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint; end"

          '';
        };
      };
    };

    # shellInit = {
    # };

    # shellInitLast = {
    # };
  };
}
