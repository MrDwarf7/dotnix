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

  config = lib.mkIf config.sopsSecrets.enable {
    sops.defaultSopsFile = ../secrets/wifi.yaml;
    sops.validateSopsFiles = true;

    sops.defaultSopsFormat = "yaml";
    # sops.age.sshKeyPaths = [
    #   ../../../.ssh/arch_id_ed25519
    #   # "/home/dwarf/.ssh/id_ed25519"
    # ];
    sops.age.keyFile = "/home/dwarf/.config/sops/age/keys.txt";
    # "../../../.config/sops/age/keys.txt";

    sops.secrets = {
      home_ssid = {};
      home_pass = {};
    };
  };
}
