{
  inputs,
  lib,
  config,
  ...
}: {
  options = {
    nixModule.enable = lib.mkEnableOption "Enable nix settings";
  };

  config = lib.mkIf config.nixModule.enable {
    nixpkgs.config.allowUnfree = true;
    system.stateVersion = "25.05";
    nix = {
      # gc = {
      #   automatic = true;
      #   dates = "weekly";
      #   options = "--delete-older-than 30d";
      # };
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];

      registry = {
        nixpkgs.flake = inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs
        # nixpkgs-stable.flake = inputs.nixpkgs-stable;
      };

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

        substituters = [
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
      enable = true;
      # enableNg = true;
    };
  };
}
