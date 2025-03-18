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
    };

    programs.yazi = {
      enableFishIntegration = true;
    };

    programs.fish = {
      enable = true;
      shellAliases = {
        l = "ls -lah";
        la = "ls -lah";
        cls = "clear";
        ca = "clear && ls -lah";
        ef = "exec fish";
        lg = "lazygit";
        b = "bat";
        c = "cat";
        nos = "nh os switch";
        nhs = "nh home switch";

        g = "git";
        gf = "git fetch";
        gst = "git status";
        ga = "git add";
        gaa = "git add --all";
        gb = "git branch";
        gba = "git branch -a";
        gc = "git commit";
        gcb = "git checkout -b";
        gcl = "git clone --recursive";
        grl = "git reflog -5";
        gpl = "git pull";
        gpla = "git pull --all";

        gd = "git diff";
        gfp = "git fetch --all && git pull";
        gp = "git push";
        gco = "git checkout";
        grv = "git remote -v";
      };
      interactiveShellInit = ''
            if test -e starship; and test -x starship
                starship init fish | source
                commandline -f repaint
            end
        fish_vi_key_bindings
        set -gx fish_greeting # Disable the greeting thing
        set -Ux CARAPACE_BRIDGES 'all'
      '';

      functions = {
        GetGitMainBranch = {
          body = ''
                # Check if we're in a git repository
                git rev-parse --git-dir >/dev/null 2>&1
                if test $status -ne 0
                    return
                end

                # Array of possible main branches
                set branches main trunk

                # Loop through branches
                for branch in $branches
                    git show-ref -q --verify refs/heads/$branch >/dev/null 2>&1
                    if test $status -eq 0
                        echo $branch
                        return
                    end
            end
          '';
        };

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

        gcm = {
          body = ''
            set MainBranch (GetGitMainBranch)
            git checkout $MainBranch $argv
          '';
        };

        dot = {
          body = ''
            pushd $DOT_DIR || return 1
            git fetch --all
            git status
            # check if the output actually fetched anything before askign user to pull
            if git status | grep -q 'Your branch is behind'; and git status | grep -q 'nothing to commit'; and git status | grep -q 'working tree clean'
                echo "Would you like to pull the latest changes?"
                read -l -P "pull [y/N]: " pull
                if test "$pull" = "y" || test "$pull" = "Y"
                    git pull
                end
            end
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
