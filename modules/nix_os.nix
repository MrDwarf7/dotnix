{
  lib,
  config,
  ...
}: {
  options = {
    nixModule.enable = lib.mkEnableOption "Enable nix settings";
    nixModule.stateVersion = lib.mkOption {
      type = lib.types.str;
      default = "25.05";
      description = "The state version to use";
    };
  };

  config = lib.mkIf config.nixModule.enable {
    nixpkgs.config.allowUnfree = true;
    system.stateVersion = config.nixModule.stateVersion;
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      settings = {
        experimental-features = ["nix-command" "flakes"];
        max-jobs = 3;
        trusted-users = ["builder "];
      };
      optimise.automatic = true;
    };
  };
}
