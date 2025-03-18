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
      # gc = {
      #   automatic = true;
      #   dates = "weekly";
      #   options = "--delete-older-than 30d";
      # };

      settings = {
        experimental-features = ["nix-command" "flakes" "recursive-nix" "ca-derivations"];
        allowed-users = ["builder" "@wheel"];
        trusted-users = ["builder" "@wheel"];
        auto-optimise-store = true;
        builders-use-substitutes = true;
        accept-flake-config = true;
        keep-outputs = true;
        warn-dirty = false; # Turn off the annoying af warning
        max-jobs = "auto";
        log-lines = 20;

        subsituters = [
          "https://cache.nixos.org"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
      };
      optimise.automatic = true;
    };

    systemd.services.nix-daeomon = {
      environment.TMPDIR = "/var/tmp"; # Don't build stuff on TMPFS lol
    };
    system.switch = {
      enable = false;
      enableNg = true;
    };
  };
}
