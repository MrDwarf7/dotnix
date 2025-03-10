{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options = {
    program.cliDev.enable = lib.mkEnableOption "Enable the CLI development programs";
  };

  config = lib.mkIf config.program.cliDev.enable {
    environment.systemPackages = with pkgs; [
      alejandra
      gh
      git
    ];
  };
}
