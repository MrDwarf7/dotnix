{
  # inputs,
  config,
  lib,
  pkgs,
  ...
}:
# yazi-legacyPackages = inputs.nix-yazi-plugins.legacyPackages.x86_64-linux;
{
  # imports = [
  #   (yazi-legacyPackages.homeManagerModules.default)
  # ];

  options = {
    home.yazi.enable = lib.mkEnableOption "Enable yazi file manager";
  };

  config = lib.mkIf config.home.yazi.enable {
    programs.yazi = {
      enable = true;
      initLua = ./init.lua;
      keymap = pkgs.lib.importTOML ./keymap.toml;
      theme = pkgs.lib.importTOML ./tokyo-night-yazi.toml; # https://github.com/BennyOe/tokyo-night.yazi.git
      # flavors = pkgs.fetchFromGitHub {
      #   url = "https://github.com/BennyOe/tokyo-night.yazi.git";
      #   rev = "master";
      # };
      settings = pkgs.lib.importTOML ./settings.toml;
      # plugins = config.lib.file.mkOutOfStoreSymlink {
      #   name = "yazi-plugins";
      #   target = pkgs.lib.importTOML ./plugins.toml;
      # };
    };
  };
}
