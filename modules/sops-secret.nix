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
    home.sopsSecrets.enable = lib.mkEnableOption "Enable sops-secret";
  };

  config = lib.mkIf config.home.sopsSecrets.enable {
    sops.defaultSopsFile = ../../../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "/home/dwarf/.config/sops/age/keys.txt";

    sops.secrets."wifi/CocaCola" = {
      # owner = "wifi-secret-service";
      # owner = config.users.users.dwarf.name;
    };

    # systemd.services."wifi-secret" = {
    #   script = ''
    #     # !/usr/bin/env bash
    #     set -e
    #     cat <<EOF > /var/lib/wifi-service/wifi-secret | nmcli password wifi CocaCola file /var/lib/wifi-service/wifi-secret
    #     ${config.sops.secrets."wifi/CocaCola".secret}
    #     EOF
    #   '';
    #   serviceConfig = {
    #     User = "wifi-secret-service";
    #     WorkingDirectory = "/var/lib/wifi-service";
    #   };
    # };

    # users.users.wifi-secret-service = {
    #   home = "/var/lib/wifi-service";
    #   createHome = true;
    #   isSystemUser = true;
    #   extraGroups = ["networkmanager"];
    # };
    # users.groups.wifi-secret-service = {};
  };
}
