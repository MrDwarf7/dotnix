{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options = {
    #                                    # lib.mkEnableOption "Enable sops-secret";
    sopsSecrets.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable sops-secret";
    };
  };

  ### TODO: Ensure this is working correctly?????
  config = lib.mkIf config.sopsSecrets.enable {
    sops.defaultSopsFormat = "yaml";
    sops.validateSopsFiles = false;

    sops.defaultSopsFile = ./../secrets/secrets.yaml;
    # sops.age.keyFile = "/home/dwarf/.config/sops/age/keys.txt";
    sops.age.keyFile = "/etc/keys.txt";
    sops.age.generateKey = true;

    sops.age.sshKeyPaths = [
      "/home/dwarf/.ssh/arch_id_ed25519"
    ];

    sops.secrets."home_wifi/cocacola/ssid" = {
      # neededForUsers = true;
    };
    sops.secrets."home_wifi/cocacola/pass" = {
      # neededForUsers = true;
    };

    sops.secrets."phone_wifi/iphone_wifi/ssid" = {
      # neededForUsers = true;
    };
    sops.secrets."phone_wifi/iphone_wifi/pass" = {
      # neededForUsers = true;
    };

    # Not making any use of these currently - best to just comment them out for now
    # sops.templates = {
    #   "home_wifi_ssid".content = ''${config.sops.placeholder."home_wifi/cocacola/ssid"}'';
    #   "home_wifi_pass".content = ''${config.sops.placeholder."home_wifi/cocacola/pass"}'';
    # };
    # "phone_wifi_ssid".content = ''${config.sops.placeholder."phone_wifi/iphone_wifi/ssid"}'';
    # "phone_wifi_pass".content = ''${config.sops.placeholder."phone_wifi/iphone_wifi/pass"}'';
  };
}
