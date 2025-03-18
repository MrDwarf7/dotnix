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

    networking.useDHCP = true; # Use it GLOBALY

    networking.networkmanager = {
      enable = true;
      unmanaged = ["docker0"];
      wifi = {
        powersave = true;
        backend = "wpa_supplicant";
      };
    };

    networking.wireless.enable = true;
    # networking.networkmanager.enable = true; ## Wired
    networking.wireless.scanOnLowSignal = false; # Will make changing quicker, but drains battery (and can be annoying while debugging etc. too)

    # networking.wireless.interfaces = [
    #   device
    # ];

    #### TODO: sops-nix plz.
    # networking.wireless.secretsFile = config.sops.defaultSopsFile;
    # networking.wireless.userControlled.enable = true;
    networking.wireless.networks = {
      "CocaCola" = {
        psk = "$(cat ${pass})";
      };
    };
    networking.useNetworkd = true;
    systemd.network.enable = true;
  };
}
# Allow for `http://👻` thx to @elmo@chaos.social
# networking.hosts = {
#   "127.0.0.1" = ["xn--9q8h" "localghost"];
# };

