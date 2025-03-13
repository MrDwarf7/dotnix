{
  pkgs,
  config,
  lib,
  ...
}: let
  asMins = mins: 60 * mins;
  lock = "pidof hyprlock || hyprlock";
  lockWarning = 30;
  lockTimeout = asMins 5;
  # 60 * 5;
  suspendTimeout = asMins 20;
  # 60 * 10;
in {
  options = {
    home.hypridle.enable = lib.mkEnableOption "Enable hypridle (config)";
  };

  config = lib.mkIf config.home.hypridle.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = lock;
          before_sleep_cmd = lock;
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = lockTimeout - lockWarning;
            on-timeout = "${pkgs.libnotify}/bin/notify-send -t 3000 'Locking' 'This computer locks in ${toString lockWarning} seconds'";
          }
          {
            timeout = lockTimeout;
            on-timeout = lock;
          }
          {
            timeout = suspendTimeout;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
