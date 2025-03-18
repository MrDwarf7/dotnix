{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  device = "wlp3s0";
  pass = config.sops.secrets."home_wifi/cocacola/pass".path;
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

    # Drastically slows down boot times for basically no benefit
    systemd.services.NetworkManager-wait-online.enable = false;
    networking.dhcpcd.extraConfig = "nohook resolve.conf";

    networking.networkmanager = {
      enable = true;
      unmanaged = ["docker0"];
      wifi = {
        powersave = true;
        backend = "wpa_supplicant";
      };
    };

    # networking.networkmanager.enable = true;
    # Allow for `http://👻` thx to @elmo@chaos.social
    # networking.hosts = {
    #   "127.0.0.1" = ["xn--9q8h" "localghost"];
    # };
    networking.wireless.enable = true;
    networking.wireless.scanOnLowSignal = false; # Will make changing quicker, but drains battery (and can be annoying while debugging etc. too)
    networking.useDHCP = true; # Use it GLOBALY
    # networking.wireless.interfaces = [
    #   device
    # ];

    #### TODO: sops-nix plz.
    # networking.wireless.secretsFile = config.sops.defaultSopsFile;
    networking.wireless.userControlled.enable = true;
    networking.wireless.networks = {
      "CocaCola" = {
        # "${config.sops.templates."home_wifi_ssid".content}" = {
        psk = "$(cat ${pass})";
      };
      # Generate the set via:
      # sudo wpa_passphrase "YourSSID" "YourPassword" > /etc/wpa_supplicant.conf

      # "ext:HOME_WIFI_SSID" = {
      #   pskRaw = "ext:HOME_WIFI_PASSWORD";
      # };
    };
    networking.useNetworkd = true;
    systemd.network.enable = true;

    # systemd.services."wpa_supplicant" = {
    #   enable = true;
    #   after = ["sops-nix.service"];
    #   wants = ["network-pre.target"];
    #   before = ["network.target" "systemd-networkd.service"];
    #   unitConfig = {
    #     ConditionCapability = "CAP_NET_ADMIN";
    #   };
    #   serviceConfig = {
    #     ExecStart = lib.mkForce ''          ip link set ${device} up &&\
    #               ${pkgs.wpa_supplicant}/sbin/wpa_supplicant -B -i ${device} -c /etc/wpa_supplicant.conf
    #     '';
    #   };
    # };

    # systemd.network.networks."40-wifi" = {
    #   matchConfig.Name = "${device}";
    #   networkConfig.DHCP = "yes"; # Use it for this specific interface
    #   serviceConfig = {
    #     ExecStart = "${pkgs.wpa_supplicant}/sbin/wpa_supplicant -c/etc/wpa_supplicant.conf -i${device} -Dnl80211,wext";
    #   };
    # };

    ## TEST: disabling
    # systemd.user.services.mbsync.unitConfig.After = ["sops-nix.service"];
    # systemd.services."wpa_supplicant" = {
    #   enable = true;
    #   after = ["sops-nix.service"];
    #   wants = ["network-pre.target"];
    #   before = ["network.target" "systemd-networkd.service"];
    #   unitConfig = {
    #     ConditionCapability = "CAP_NET_ADMIN";
    #   };

    ## Need to call lib.mkForce on ExecStart to override the default if using a hardwritten /etc/wpa_supplicant.conf instead of sops
    #   serviceConfig = {
    #     ExecStart = "${pkgs.wpa_supplicant}/sbin/wpa_supplicant -B -i ${device} -c /etc/wpa_supplicant.conf ";
    #   };
    # };
  };
}
