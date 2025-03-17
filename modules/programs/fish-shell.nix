{
  pkgs,
  lib,
  config,
  ...
}: {
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

    # pkgs.program.fish = {
    #   shellAliases = {
    #     l = "ls -lah";
    #     la = "ls -lah";
    #     cls = "clear";
    #     ca = "clear && ls -lah";
    #     ef = "exec fish";
    #     lg = "lazygit";
    #     b = "bat";
    #     c = "cat";
    #     nos = "nh os switch";
    #     nhs = "nh home switch";
    #     gfp = "git fetch --all && git pull";
    # };
    # functions = {
    #   md = {
    #     body = ''
    #         mkdir -p $argv
    #       '';
    #     };
    #     fish_user_key_bindings = {
    #       body = ''
    #         set -x fish_sequence_key_delay_ms 160
    #
    #         bind -M default H beginning-of-line
    #         bind -M default L end-of-line
    #
    #         bind -M visual H beginning-of-line
    #         bind -M visual L end-of-line
    #
    #         bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint; end"
    #         bind -M insert jj "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint; end"
    #         bind -M insert kj "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint; end"
    #         bind -M insert kk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint; end"
    #
    #       '';
    #     };
    #   };
    # };
  };
}
