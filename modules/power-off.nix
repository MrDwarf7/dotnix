{
  lib,
  config,
  ...
}: {
  options = {
    powerOff.enable = lib.mkEnableOption "Enable the poweroff config";
  };
  config = lib.mkIf config.powerOff.enable {
    services.logind = {
      powerKey = "poweroff";
      lidSwitch = "suspend";
      extraConfig = ''
        # Don't shutdown when short-pressed, require a hold/long press to power off
        HandlePowerKey=ignore
      '';
    };

    services.upower = {
      enable = true;
      criticalPowerAction = "Hibernate";
      percentageLow = 7;
      percentageCritical = 6;
      percentageAction = 5;
    };
  };
}
