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
    sops.defaultSopsFile = ./../secrets/secrets.yaml;
    sops.validateSopsFiles = true;

    sops.defaultSopsFormat = "yaml";
    # sops.age.sshKeyPaths = [
    #   ../../../.ssh/arch_id_ed25519
    #   # "/home/dwarf/.ssh/id_ed25519"
    # ];
    sops.age.sshKeyPaths = [
      "/home/dwarf/.ssh/arch_id_ed25519"
    ];
    sops.age.keyFile = "/home/dwarf/.config/sops/age/keys.txt";
    # "../../../.config/sops/age/keys.txt";
    sops.age.generateKey = true;

    sops.secrets."wireless.env" = {
      neededForUsers = true;
      path = "/run/secrets/wireless.env";
      mode = "0400";
    };

    # sops.secrets.wifi = {
    #   format = "yaml";
    #   sopsFile = "../secrets/wifi.yaml";
    #   key = "";
    # };
    #
    # sops.secrets.home_ssid = {
    #       neededForUsers = true;
    #       path = "/run/secrets/home_ssid";
    #       mode = "0400";
    #       owner = "root";
    #       group = "root";
    #     restartUnits = [ "networking.service" ];
    #   };
    #
    # sops.secrets.home_pass = {
    #       neededForUsers = true;
    #       path = "/run/secrets/home_pass";
    #       mode = "0400";
    #       owner = "root";
    #       group = "root";
    #     restartUnits = [ "networking.service" ];
    #   };
    };
}
