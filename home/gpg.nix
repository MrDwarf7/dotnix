{
  config,
  lib,
  ...
}: {
  options = {
    home.gpg.enable = lib.mkEnableOption "Enable gpg (config)";
    #   home.gpg.email = lib.mkOption {
    #     type = lib.types.str;
    #     default = "";
    #     description = "The gpg email address";
    # };
    home.gpg.homedir = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/.gnupg";
    };
  };

  config = lib.mkIf config.home.gpg.enable {
    programs.gpg = {
      enable = true;
      homedir = config.home.gpg.homedir;
      # email = config.home.gpg.email;
      mutableKeys = true; # Allows user mutatiosn of the keyring, otherwise is immutable lin in Nix store
      mutableTrust = true; # Similar to mutableKeys, but for trustdb.gpg

      publicKeys = [
        {
          name = "MrDwarf7";
          email = "129040985+MrDwarf7@users.noreply.github.com";
        }
      ];
    };
  };
}
