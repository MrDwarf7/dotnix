{
  lib,
  config,
  ...
}: {
  options = {
    firewall.enable = lib.mkEnableOption "Enable the firewall";
    firewall.tcp = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      description = "Allowed TCP Ports";
      default = [];
    };

    firewall.udp = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      description = "Allowed UDP Ports";
      default = [];
    };
  };

  config = lib.mkIf config.firewall.enable {
    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = config.firewall.tcp;
    networking.firewall.allowedUDPPorts = config.firewall.udp;
  };
}
