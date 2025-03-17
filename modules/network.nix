{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  home_ssid = config.sops.secrets.home_ssid.path;
  home_pass = config.sops.secrets.home_pass.path;

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
    networking.wireless.secretsFile = config.sops.defaultSopsFile;
    networking.wireless.networks = {
        "${home_ssid}" = {
        psk = home_pass;
        };
    };

    networking.useNetworkd = true;
    systemd.network.enable = true;
    systemd.network.networks."40-wifi" = {
      matchConfig.Name = "${device}";
      networkConfig.DHCP = "yes"; # Use it for this specific interface
    };

    systemd.services."wpa_supplicant" = {
      after = ["sops-nix.service"];
      wants = ["network-pre.target"];
      before = ["network.target" "systemd-networkd.service"];
      unitConfig = {
        ConditionCapability = "CAP_NET_ADMIN";
      };
    };

    networking.useDHCP = false; # Use it GLOBALY
  };
}
