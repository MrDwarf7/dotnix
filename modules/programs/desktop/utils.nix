{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    program.desktop.utils.enable = lib.mkEnableOption "Enable utils";
  };

  config = lib.mkIf config.program.desktop.utils.enable {
    environment.systemPackages = with pkgs; [
      galculator
      pika-backup
      resources
      nautilus
      # Testing
      wpa_supplicant
      wpa_supplicant_gui
      networkmanager
      networkmanagerapplet
      zathura
      # timeshift
    ];
  };
}
