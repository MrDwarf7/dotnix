{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    home.git.enable = lib.mkEnableOption "Enable git (config)";
    home.git.userName = lib.mkOption {
      type = lib.types.str;
      default = "MrDwarf7";
      description = "The git username";
    };
    home.git.email = lib.mkOption {
      type = lib.types.str;
      default = "129040985+MrDwarf7@users.noreply.github.com";
      description = "The git email address";
    };
  };

  config = lib.mkIf config.home.git.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;

      userName = config.home.git.userName;
      userEmail = config.home.git.email;
      aliases = {
        last = "log -1 HEAD";
        wt-bare = "!sh $HOME/dotfiles/git-clone-worktrees.sh";
        wta = "worktree add";
        wtl = "worktree list";
        wtr = "worktree remove";
        wtm = "worktree move";
        s- = "switch -";
        fa = "fetch --all";
        pla = "pull --all";
        pa = "push --all";
        rs = "restore --staged";
        cm = "commit -m";
        rlast = "reflog -5 HEAD";
        sut = "branch --set-upstream-to";
        undo = "reset --soft HEAD~1";
        undoh = "reset --hard HEAD~1";
        unst = "restore --staged";
        uncm = "reset --soft HEAD~1";
      };

      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
        core.excludesfile = "${config.home.homeDirectory}/.gitignore_global";
        core.pager = "delta";
        interactive.singleKey = true;
        interactive.diffFilter = "delta --color-only";
        delta.navigate = true;
        delta.dark = true;
        delta.line-numbers = true;
        merge.conflictStyle = "diff3";
        diff.colorMoved = "default";

        credential = {
          "https://github.com" = {
            helper = [
              "" # Clear default helper
              "!${pkgs.gh}/bin/gh auth git-credential"
            ];
          };
          "https://gist.github.com" = {
            helper = [
              "" # Clear default helper
              "!${pkgs.gh}/bin/gh auth git-credential"
            ];
          };
        };

        push.autoSetupRemove = true;

        filter.lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };

        safe.directory = [
          "*"
          "/etc/nixos/*"
          "/home/dwarf/dotnix"
        ];
      };
    };
  };
}
