{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.hostName = "nixbook";
  networking.wireless.enable = true;
  networking.wireless.networks = {
    CocaCola = {
      psk = secret: config.sops.secrets."wifi/CocaCola".secret;
      # key_mgmt = "WPA-PSK";
    };
  };
  networking.firewall.enable = false; # CHANGE AFTER INSTALL
}
