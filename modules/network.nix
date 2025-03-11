{
  pkgs,
  lib,
  config,
  ...
}: let
  home_ssid = config.sops.secrets.home_ssid;
  # home_pass = lib.mkString config.sops.secrets.home_pass;
in {
  options = {
    networkModule.enable = lib.mkEnableOption "Enable the custom network module";
    networkModule.hostName = lib.mkOption {
      type = lib.types.str;
      default = "nixbook";
      description = "The hostname";
    };
  };

  config = lib.mkIf config.networkModule.enable {
    networking.hostName = config.networkModule.hostName;
    # networking.networkmanager.enable = true;
    # Allow for `http://👻` thx to @elmo@chaos.social
    networking.hosts = {
      "127.0.0.1" = ["xn--9q8h" "localghost"];
    };
    networking.wireless.enable = true;
    networking.wireless.networks = {
      home_ssid = {
        psk = null;
        # home_pass;
      };
    };

    lib.systemd.services.set-wifi-password = {
      # systemd.services.set-wifi-password = {
      inherit home_ssid pkgs config;
      description = "Set the wifi password";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.networkmanager}/bin/nmcli con mod "$(cat ${config.sops.secrets.home_ssid.path})" wifi-sec.psk "$(cat ${config.sops.secrets.home_pass.path})"
        '';
        # ${pkgs.networkmanager}/bin/nmcli con mod ${home_ssid} wifi-sec.psk ${home_ssid.psk}
      };
      RemainAfterExit = true; ## Not a real option
    };
  };
}
