{
  pkgs ?
    import <nixpkgs> {
      overlays = [
        (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
        (self: super: {
          rustToolchain = super.rust-bin.nightly.latest.default;
        })
      ];
    },
}: let
  alejandra = import (fetchTarball {
    url = "https://github.com/kamadorueda/alejandra/archive/3.1.0.tar.gz";
  }) {inherit pkgs;};
  # agenix = import (fetchTarball {
  #   url = "https://github.com/ryantm/agenix/archive/0.15.0.tar.gz";
  # }) {inherit pkgs;};
in
  pkgs.mkShell {
    buildInputs = with pkgs;
      [
        # TODO: Not sure we really need agenix // agenix-cli ??
        age
        # agenix
        # agenix-cli
        alejandra # Alejandra Nix formatter
        direnv
        fish # Fish shell
        nixd # Nix language server
        omnix
        # rustToolchain # Rust stable toolchain (cargo, clippy, rustfmt, etc.)
        sops
        ssh-to-age
        ssh-to-pgp
      ]
      ++ lib.optionals stdenv.isDarwin [libiconv]; # Add libiconv for macOS

    shellHook = ''
      # Ensure direnv is loaded when entering the shell
      eval "$(direnv hook $SHELL)"
    '';
  }
