{pkgs, ...}: {
  nixpkgs.overlays = [
    #
  ];

  environment.systemPackages = with pkgs; [
    lua # Lua
    lua-language-server # Lua
    sumneko-lua-language-server # Lua
  ];
}
