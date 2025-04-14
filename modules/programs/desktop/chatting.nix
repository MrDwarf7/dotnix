{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    program.desktop.chatting.enable = lib.mkEnableOption "Enable chatting programs";
  };

  config = lib.mkIf config.program.desktop.chatting.enable {
    environment.systemPackages = with pkgs;
      [
        # vencord
        vesktop
        # zulip
        # element-desktop
        discord
        signal-desktop-bin
        telegram-desktop
      ]
      ++ (
        if pkgs.stdenv.isx86_64
        then [discord-canary]
        else []
      );
  };
}
