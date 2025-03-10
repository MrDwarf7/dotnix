# Lua
{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    program.languages.lua.enable = lib.mkEnableOption "Enable the Lua programming language";
  };

  config = lib.mkIf config.program.languages.lua.enable {
    nixpkgs.overlays = [
    ];
    environment.systemPackages = with pkgs; [
      lua # Lua
      lua-language-server # Lua
      sumneko-lua-language-server # Lua
    ];
  };
}
