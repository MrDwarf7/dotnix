{
  lib,
  config,
  inputs,
  ...
}: let
  device = "wlp3s0";
  pass = config.sops.secrets."home_wifi/cocacola/pass".path;
  iphone_pass = config.sops.secrets."phone_wifi/iphone_wifi/pass".path;
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
    # networking.dhcpcd.extraConfig = "nohook resolve.conf"; ## May be useful? need to read doc

    # TEST: New things
    networking.enableB43Firmware = true;
    # networking.wireless.driver = "b43"; #??? -- crashes wpa_supplicant on rebuild lol??
    # networking.wireless.secretsFile = "${pkgs.sops}/bin/sops"; ? which one?
    # networking.wireless.secretsFile = "/home/dwarf/.config/sops/age/keys.txt"; ? which one?

    # networking.useDHCP = true; # Use it GLOBALY

    networking.networkmanager = {
      enable = true;
      unmanaged = ["docker0"];
      wifi = {
        powersave = false;
        backend = "wpa_supplicant";
        scanRandMacAddress = false;
        macAddress = "permanent";
      };
    };

    # IF WE ARE USING NetworkManager, this should be FALSE
    networking.wireless.enable = false;
    # networking.wireless.scanOnLowSignal = false; # Will make changing quicker, but drains battery (and can be annoying while debugging etc. too)

    networking.wireless.interfaces = [
      device
    ];

    networking.wireless.networks = {
      "CocaCola" = {
        psk = "${pass}";
        priority = 10;
      };

      "Blake's iPhone" = {
        psk = "${iphone_pass}";
        priority = 1;
      };

      # Same as above, just via the BSSID instead
      # "B2:80:8E:FE:41:90" = {
      #   psk = ''${iphone_pass}'';
      #   priority = 1;
      # };
    };

    ## TESTING: turned off 26/27 April 2025
    # networking.useNetworkd = true;
    # systemd.network.enable = true;
    # systemd.network.wait-online = false;
  };
}
# Allow for `http://👻` thx to @elmo@chaos.social
# networking.hosts = {
#   "127.0.0.1" = ["xn--9q8h" "localghost"];
# };

