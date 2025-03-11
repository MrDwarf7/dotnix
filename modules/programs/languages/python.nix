# Python
{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    program.languages.python.enable = lib.mkEnableOption "Enable the Python programming language";
  };

  config = lib.mkIf config.program.languages.python.enable {
    nixpkgs.overlays = [
    ];
    environment.systemPackages = with pkgs; [
      python313Full
      python313FreeThreading
      # python313Packages
      # python313Packages.lsp-tree-sitter
      # python313Packages.ruff
      # python313Packages.uv
      python313Packages.black
      ruff
      pyright
      uv
      black
    ];
  };
}
