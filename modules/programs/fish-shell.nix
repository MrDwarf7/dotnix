{
  pkgs,
  lib,
  config,
  ...
}: let

in {
  options = {
    program.fishShell.enable = lib.mkEnableOption "Enable the Fish shell";
  };

  config = lib.mkIf config.program.fishShell.enable {
    users.users.dwarf.shell = pkgs.fish;
    users.users.root.shell = pkgs.fish;
    environment.systemPackages = with pkgs; [
      fish
      starship
      zoxide
    ];

    # nixpkg.program.fish = {
    #     enable = true;
    #     shellAliases = {
    #         l = "ls -lah";
    #         la = "ls -lah";
    #         cls = "clear";
    #         ca = "clear && ls -lah";
    #         ef = "exec fish";
    #         lg = "lazygit";
    #         b = "bat";
    #         c = "cat";
    #         nos = "nh os switch";
    #         nhs = "nh home switch";
    #         ma = "makers";
    #         aa = "jj";
    #
    #         g = "git";
    #         gf = "git fetch";
    #         gst = "git status";
    #         ga = "git add";
    #         gaa = "git add --all";
    #         gb = "git branch";
    #         gba = "git branch -a";
    #         gc = "git commit";
    #         gcb = "git checkout -b";
    #         gcl = "git clone --recursive";
    #         grl = "git reflog -5";
    #         gpl = "git pull";
    #         gpla = "git pull --all";
    #
    #         gd = "git diff";
    #         gfp = "git fetch --all && git pull";
    #         gp = "git push";
    #         gco = "git checkout";
    #         grv = "git remote -v";
    #     };
    #     functions = {
    #         fish_user_key_bindings = {
    #         body = ''
    #             set -x fish_sequence_key_delay_ms 160
    #             bind -M default H beginning-of-line
    #             bind -M default L end-of-line
    #
    #             bind -M visual H beginning-of-line
    #             bind -M visual L end-of-line
    #
    #             bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint; end"
    #             bind -M insert jj "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint; end"
    #             bind -M insert kj "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint; end"
    #             bind -M insert kk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint; end"
    #         '';
    #         };
    #         md = {
    #         body = ''
    #             mkdir -p $argv
    #         '';
    #         };
    #         y = {
    #         body = ''
    #             set tmp (mktemp -t "yazi-cwd.XXXXXX")
    #             yazi $argv --cwd-file="$tmp"
    #             if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
    #                 builtin cd -- "$cwd"
    #             end
    #             rm -f -- "$tmp"
    #         '';
    #         };
    #       };
    #     };
    };
}
