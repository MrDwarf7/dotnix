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
      device
    ];

    #### TODO: sops-nix plz.
    networking.wireless.secretsFile = config.sops.secrets."wireless.env".path;
    # networking.wireless.environmentFile = config.sops.secrets."wireless.env".path;
    networking.wireless.userControlled.enable = true;
    networking.wireless.networks = {
      # Generate the set via:
      # sudo wpa_passphrase "YourSSID" "YourPassword" > /etc/wpa_supplicant.conf
      # and /etc/wpa_supplicant.conf is the file it looks for by default
      # Saves having to stuff about with sops-nix bs
    };
    networking.useNetworkd = true;
    systemd.network.enable = true;
    # systemd.network.networks."40-wifi" = {
    #   matchConfig.Name = "${device}";
    #   networkConfig.DHCP = "yes"; # Use it for this specific interface
    #   serviceConfig = {
    #     ExecStart = "${pkgs.wpa_supplicant}/sbin/wpa_supplicant -c/etc/wpa_supplicant.conf -i${device} -Dnl80211,wext";
    #   };
    # };

    systemd.user.services.mbsync.unitConfig.After = ["sops-nix.service"];
    systemd.services."wpa_supplicant" = {
      enable = true;
      after = ["sops-nix.service"];
      wants = ["network-pre.target"];
      before = ["network.target" "systemd-networkd.service"];
      unitConfig = {
        ConditionCapability = "CAP_NET_ADMIN";
      };
      serviceConfig = {
        ExecStart = "${pkgs.wpa_supplicant}/sbin/wpa_supplicant -B -i ${device} -c /etc/wpa_supplicant.conf ";
      };
    };

    networking.useDHCP = true; # Use it GLOBALY
  };
}
