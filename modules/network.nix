{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  device = "wlp3s0";
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

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
    networking.wireless.scanOnLowSignal = false; # Will make changing quicker, but drains battery (and can be annoying while debugging etc. too)
    networking.wireless.interfaces = [
     "${device}"
    ];

    #### TODO: sops-nix plz.
    networking.wireless.secretsFile = config.sops.secrets."wireless.env".path;
    # networking.wireless.environmentFile = config.sops.secrets."wireless.env".path;
    networking.wireless.userControlled.enable = true;
    networking.wireless.networks = {
        "ext:HOME_WIFI_SSID" = {
            pskRaw = "ext:HOME_WIFI_PASSWORD";
        };
    };
    # networking.wireless.networks = {
    #   "CocaCola" = {
    #             psk = config.sops.secrets.home_pass;
    #         };
    # };

    networking.useNetworkd = true;
    systemd.network.enable = true;
    systemd.network.networks."40-wifi" = {
      matchConfig.Name = "${device}";
      networkConfig.DHCP = "yes"; # Use it for this specific interface
    };

    # systemd.user.services.mbsync.unitConfig.After = [ "sops-nix.service" ];

    # systemd.services."wpa_supplicant" = {
    #   after = ["sops-nix.service"];
    #   wants = ["network-pre.target"];
    #   before = ["network.target" "systemd-networkd.service"];
    #   unitConfig = {
    #     ConditionCapability = "CAP_NET_ADMIN";
    #   };
    # };

    networking.useDHCP = false; # Use it GLOBALY
  };
}
