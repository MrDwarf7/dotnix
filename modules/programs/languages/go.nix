{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    program.languages.go.enable = lib.mkEnableOption "Enable the Go programming language";
  };

  config = lib.mkIf config.program.languages.go.enable {
    nixpkgs.overlays = [
      #
    ];
    environment.systemPackages = with pkgs; [
      go # Go
      gopls
      delve
    ];
  };
}
