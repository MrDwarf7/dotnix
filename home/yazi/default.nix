{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    home.yazi.enable = lib.mkEnableOption "Enable yazi file manager";
  };

  config = lib.mkIf config.home.yazi.enable {
    programs.yazi = {
      enable = true;

      initLua = ./init.lua;
      # keymap = pkgs.lib.importTOML ./keymap.toml;
      # settings = pkgs.lib.importTOML ./settings.toml;
      theme = pkgs.lib.importTOML ./tokyo-night-yazi.toml; # https://github.com/BennyOe/tokyo-night.yazi.git

      settings = {
        manager = {
          show_hidden = true;
          show_symlink = true;
          linemode = "mtime_better";
          sort_by = "natural";
        };
        opener = {
          edit = [
            {
              run = "nvim \"$@\"";
              block = true;
              for = "unix";
            }
            {
              run = "nvim %*";
              block = true;
              desc = "nvim (block)";
              for = "windows";
            }
          ];
          open = [
            {
              run = "nvim %*";
              block = true;
              desc = "nvim (block)";
              for = "windows";
            }
          ];
          reveal = [];
          extract = [];
          play = [];
        };
        open = {
          prepend_rules = [
            {
              name = ".gitconfig";
              run = "nvim %*";
              use = [
                "open"
                "edit"
              ];
              for = "windows";
            }
            {
              name = ".gitconfig";
              run = "nvim $@";
              use = [
                "open"
                "edit"
              ];
              for = "unix";
            }
          ];
        };
        plugin = {
          prepend_previewers = [
            {
              mime = "text/csv";
              run = "miller";
            }
            {
              name = "*.md";
              run = "rich-preview";
            }
            {
              name = "*.ipynb";
              run = "rich-preview";
            }
            {
              name = "*.json";
              run = "rich-preview";
            }
            {
              name = "*.jsonc";
              run = "rich-preview";
            }
            {
              mime = "application/*zip";
              run = "ouch";
            }
            {
              mime = "application/x-tar";
              run = "ouch";
            }
            {
              mime = "application/x-bzip2";
              run = "ouch";
            }
            {
              mime = "application/x-7z-compressed";
              run = "ouch";
            }
            {
              mime = "application/x-rar";
              run = "ouch";
            }
            {
              mime = "application/x-xz";
              run = "ouch";
            }
            {
              mime = "application/zstd";
              run = "ouch";
            }
            {
              mime = "application/x-zstd";
              run = "ouch";
            }
            {
              mime = "application/x-zstd-compressed-tar";
              run = "ouch";
            }
            {
              mime = "application/toml";
              run = "nvim %*";
            }
            {
              mime = ".gitconfig";
              run = "nvim %*";
              for = "windows";
            }
            {
              mime = ".gitconfig";
              run = "nvim $@";
              for = "unix";
            }
          ];
          prepend_fetchers = [
            {
              id = "git";
              name = "*";
              run = "git";
            }
            {
              id = "git";
              name = "*/";
              run = "git";
            }
          ];
          append_previewers = [
            {
              name = "*";
              run = "hexyl";
            }
            # # https://github.com/Reledia/glow.yazi
            # { name = "*.md"; run = "glow" };
          ];
        };
        preview = {
          max_width = 1000;
          max_height = 1000;
        };
      };

      plugins = {
        diff = "${inputs.yazi-plugins}/diff.yazi";
        git = "${inputs.yazi-plugins}/git.yazi";
        smart-enter = "${inputs.yazi-plugins}/smart-enter.yazi";
        jump-to-char = "${inputs.yazi-plugins}/jump-to-char.yazi";
        mime-ext = "${inputs.yazi-plugins}/mime-ext.yazi";

        glow = inputs.glow;
        hexyl = inputs.hexyl;
        miller = inputs.miller;
        rich-preview = inputs.rich-preview;
        ouch = inputs.ouch;
        starship = inputs.starship;
        relative-motions = inputs.relative-motions;
        eza-preview = inputs.eza-preview;

      };

      # initLua = ''
      # ---@diagnostic disable: cast-local-type
      # require("git"):setup()
      #
      # require("relative-motions"):setup({ only_motions = true })
      #
      # THEME.git_modified = ui.Style():fg("blue")
      # THEME.git_deleted = ui.Style():fg("red"):bold()
      #
      # function Linemode:mtime_better()
      #     local time = math.floor(self._file.cha.mtime or 0)
      #     if time == 0 then
      #         time = ""
      #     else
      #         time = os.date("%Y-%m-%d %I:%M %p", time)
      #     end
      #
      #     return ui.Line(string.format("%s", time))
      #     --- If you want to also have the file size displayed all the time
      #     -- local size = self._file:size()
      #     -- return ui.Line(string.format("%s %s", size and ya.readable_size(size) or "", time))
      # end
      #
      # function Linemode:ctime_better()
      #     local time = math.floor(self._file.cha.created or 0)
      #     if time == 0 then
      #         time = ""
      #     else
      #         time = os.date("%Y-%m-%d | %I:%M %p", time)
      #     end
      #
      #     return ui.Line(string.format("%s", time))
      #     --- If you want to also have the file size displayed all the time
      #     -- local size = self._file:size()
      #     -- return ui.Line(string.format("%s %s", size and ya.readable_size(size) or "", time))
      # end
      # '';

      keymap = {
        manager.prepend_keymap = [
          {
            on = "<Enter>";
            run = "plugin smart-enter";
            desc = "Enter child dir, or open file";
          }
          {
            on = "A";
            run = "create";
            desc = "Create a file (ends with / for directories)";
          }
          {
            on = "Q";
            run = "quit";
            desc = "Quit the process";
          }
          {
            on = "q";
            run = "quit --no-cwd-file";
            desc = "Quit the process without outputting cwd-file";
          }
          {
            on = "<C-c>";
            run = "close";
            desc = "Close the current tab, or quit if it's last";
          }
          {
            on = ["y" "f"];
            run = "copy path";
            desc = "Copy the file path";
          }
          {
            on = ["y" "c"];
            run = "copy dirname";
            desc = "Copy the directory path";
          }
          {
            on = ["y" "n"];
            run = "copy filename";
            desc = "Copy the filename";
          }
          {
            on = ["y" "N"];
            run = "copy name_without_ext";
            desc = "Copy the filename without extension";
          }
          {
            on = ["y" "y"];
            run = "yank";
            desc = "Yank selected files (copy)";
          }
          {
            on = ["<C-y>"];
            run = "unyank";
            desc = "Cancel the yank status";
          }
          {
            on = "<Space>";
            run = "toggle --state=none";
            desc = "Toggle the current selection state";
          }
          {
            on = "V";
            run = "visual_mode";
            desc = "Enter visual mode (selection mode)";
          }
          {
            on = "v";
            run = "visual_mode --unset";
            desc = "Enter visual mode (unset mode)";
          }
          {
            on = ["g" "d"];
            run = "plugin diff";
            desc = "Diff the selected with the hovered file";
          }
          {
            on = ["g" "i"];
            run = "plugin lazygit";
            desc = "run lazygit";
          }
          {
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory or open the file";
          }
          {
            on = ["m" "m"];
            run = "linemode mtime_better";
            desc = "Linemode: mtime_better";
          }
          {
            on = ["1"];
            run = "plugin relative-motions 1";
            desc = "Move in relative steps";
          }
          {
            on = ["2"];
            run = "plugin relative-motions 2";
            desc = "Move in relative steps";
          }
          {
            on = ["3"];
            run = "plugin relative-motions 3";
            desc = "Move in relative steps";
          }
          {
            on = ["4"];
            run = "plugin relative-motions 4";
            desc = "Move in relative steps";
          }
          {
            on = ["5"];
            run = "plugin relative-motions 5";
            desc = "Move in relative steps";
          }
          {
            on = ["6"];
            run = "plugin relative-motions 6";
            desc = "Move in relative steps";
          }
          {
            on = ["7"];
            run = "plugin relative-motions 7";
            desc = "Move in relative steps";
          }
          {
            on = ["8"];
            run = "plugin relative-motions 8";
            desc = "Move in relative steps";
          }
          {
            on = ["9"];
            run = "plugin relative-motions 9";
            desc = "Move in relative steps";
          }
          {
            on = ["C"];
            run = "plugin ouch zip";
            desc = "Compress with ouch";
          }
          {
            on = ["="];
            run = "plugin eza-preview";
            desc = "Toggle tree/list preview";
          }
        ];
      };
    };
  };
}


# glow = pkgs.fetchFromGitHub {
#     owner = "Reledia";
#     repo = "glow.yazi";
#     rev = "c76bf4f";
#     hash = "sha256-DPud1Mfagl2z490f5L69ZPnZmVCa0ROXtFeDbEegBBU=";
# };

# hexyl = pkgs.fetchFromGitHub {
#     owner = "Reledia";
#     repo = "hexyl.yazi";
#     rev = "228a9ef";
#     hash = "sha256-DPud1Mfagl2z490f5L69ZPnZmVCa0ROXtFeDbEegBBU=";
# };
# miller = pkgs.fetchFromGitHub {
#     owner = "Reledia";
#     repo = "miller.yazi";
#     rev = "40e0265";
#     hash = "sha256-DPud1Mfagl2z490f5L69ZPnZmVCa0ROXtFeDbEegBBU=";
# };
#
# rich-preview = pkgs.fetchFromGitHub {
#     owner = "AnirudhG07";
#     repo = "rich-preview.yazi";
#     rev = "2559e5f";
#     hash = "sha256-DPud1Mfagl2z490f5L69ZPnZmVCa0ROXtFeDbEegBBU=";
# };
#
# ouch = pkgs.fetchFromGitHub {
#     owner = "ndtoan96";
#     repo = "ouch.yazi";
#     rev = "558188d";
#     hash = "sha256-DPud1Mfagl2z490f5L69ZPnZmVCa0ROXtFeDbEegBBU=";
# };
#
# starship = pkgs.fetchFromGitHub {
#     owner = "Rolv-Apneseth";
#     repo = "starship.yazi";
#     rev = "6c639b4";
#     hash = "sha256-DPud1Mfagl2z490f5L69ZPnZmVCa0ROXtFeDbEegBBU=";
# };
#
# relative-motions = pkgs.fetchFromGitHub {
#     owner = "dedukun";
#     repo = "relative-motions.yazi";
#     rev = "8103065";
#     hash = "sha256-DPud1Mfagl2z490f5L69ZPnZmVCa0ROXtFeDbEegBBU=";
# };
#
# eza-preview = pkgs.fetchFromGitHub {
#     owner = "sharklasers996";
#     repo = "eza-preview.yazi";
#     rev = "7ca4c25";
#     hash = "sha256-ncOOCj53wXPZvaPSoJ5LjaWSzw1omHadKDrXdIb7G5U=";
# };
