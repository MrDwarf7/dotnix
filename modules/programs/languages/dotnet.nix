# Dotnet
{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    program.languages.dotnet.enable = lib.mkEnableOption "Enable the MS Dotnet sdk, core, and runtime";
  };

  config = lib.mkIf config.program.languages.dotnet.enable {
    nixpkgs.overlays = [
    ];
    environment.systemPackages = with pkgs; [
        # dotnet-sdk_9
        # dotnet-runtime_9
        # dotnet-aspnetcore_9
        # dotnet-ef
        # csharpier
        # omnisharp-roslyn
        # dotnet-tools
    ];
  };
}
