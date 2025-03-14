{
  pkgs,
  lib,
  config,
  ...
}: let
  home_ssid = config.sops.secrets.home_ssid;
  home_pass = lib.mkString config.sops.secrets.home_pass;
  device = "wlp2s0";
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
    # networking.hosts = {
    #   "127.0.0.1" = ["xn--9q8h" "localghost"];
    # };
    networking.wireless.enable = true;
    networking.wireless.networks = {
      home_ssid = {
        psk = null;
        # home_pass;
      };
    };

    networking.useDHCP = true; # Use it GLOBALY

    networking.interfaces.wlp350.useDHCP = true;

    networking.useNetworkd = true;
    systemd.network.networks."40-wifi" = {
      matchConfig.Name = "wlp350";
      networkConfig.DHCP = "yes"; # Use it for this specific interface
    };

    # systemd.network.networks."wlp350" = {
    #   networkConfig.DHCP = "yes";
    # };

    lib.systemd.services.set-wifi-password = {
      # systemd.services.set-wifi-password = {
      inherit home_ssid home_pass device pkgs config;
      description = "Set the wifi password";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ip link set ${device} up
          # ${pkgs.networkmanager}/bin/nmcli con mod "$(cat ${home_ssid.path})" wifi-sec.psk "$(cat ${home_pass.path})"
          wpa_supplicant -B -i ${device} -c <(wpa_passphrase "$(cat ${home_ssid.path})" "$(cat ${home_pass.path})")
          dhclient ${device}
        '';
        # ${pkgs.networkmanager}/bin/nmcli con mod ${home_ssid} wifi-sec.psk ${home_ssid.psk}
      };
      RemainAfterExit = true; ## Not a real option
    };
  };
}
