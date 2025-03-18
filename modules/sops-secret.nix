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
    sops.validateSopsFiles = true;

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

    sops.templates = {
      "home_wifi_ssid".content = ''${config.sops.placeholder."home_wifi/cocacola/ssid"}'';
      "home_wifi_pass".content = ''${config.sops.placeholder."home_wifi/cocacola/pass"}'';
      "home_wifi_test".content = ''
        network = {
          ssid = "${config.sops.placeholder."home_wifi/cocacola/ssid"}";
          #psk = "${config.sops.placeholder."home_wifi/cocacola/pass"}";
        }
      '';
    };
  };
}
