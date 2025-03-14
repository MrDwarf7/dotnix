{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  home_ssid = config.sops.secrets.home_ssid;
  home_pass = lib.ReadFile config.sops.secrets.home_pass.path;
  # device = "wlp3s0";
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
    networking.wireless.interfaces = [
      "wlp3s0"
    ];

    networking.wireless.secretsFile = config.sops.defaultSopsFile;

    networking.wireless.networks = {
      "CocaCola" = {
        psk = "/run/secrets/wifi/CocaCola";
      };
      # "${config.sops.secrets.home_ssid.key}" = {
      #   psk = config.sops.secrets.home_pass;
      # };
    };

    networking.useNetworkd = true;
    systemd.network.enable = true;
    systemd.network.networks."40-wifi" = {
      matchConfig.Name = "wlp3s0";
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

    # sops.secrets.home_ssid = {
    #   sopsFile = ../../.sops.yaml;
    #   mode = "0400";
    # };

    # sops.secrets.home_pass = {
    #   sopsFile = ../../.sops.yaml;
    #   mode = "0400";
    # };

    # boot.kernalModules = [ "brcmfmac"];

    # networking.interfaces.wlp350.useDHCP = true;
    # networking.useDHCP = true; # Use it GLOBALY
    # systemd.network.networks."wlp3s0" = {
    #   networkConfig.DHCP = "yes";
    # };
    # systemd.services.set-wifi-password = let
    #   inherit lib pkgs;
    #   home_ssid = config.sops.secrets.home_ssid;
    #   home_pass = pass: lib.mkString pass;
    #   device = "wlp3s0";
    # in {
    #   # systemd.services.set-wifi-password = {
    #   # inherit home_ssid home_pass device pkgs;
    #   description = "Set the wifi password";
    #   wantedBy = ["multi-user.target"];
    #   after = ["network.target"];
    #   serviceConfig = {
    #     Type = "oneshot";
    #     ExecStart = ''
    #       ip link set ${device} up
    #       # ${pkgs.networkmanager}/bin/nmcli con mod "$(cat ${home_ssid.path})" wifi-sec.psk "$(cat ${home_pass.path})"
    #       wpa_supplicant -B -i ${device} -c <(wpa_passphrase "$(cat ${home_ssid.path})" "$(cat ${home_pass.path})")
    #       dhclient ${device}
    #     '';
    #     # ${pkgs.networkmanager}/bin/nmcli con mod ${home_ssid} wifi-sec.psk ${home_ssid.psk}
    #   };
    #   # RemainAfterExit = true; ## Not a real option
    # };
  };
}
