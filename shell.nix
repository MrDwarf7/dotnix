{
  pkgs ?
    import <nixpkgs> {
      overlays = [
        (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
        (self: super: {
          rustToolchain = super.rust-bin.stable.latest.default;
        })
      ];
    },
}: let
  alejandra = import (fetchTarball {
    url = "https://github.com/kamadorueda/alejandra/archive/3.1.0.tar.gz";
  }) {inherit pkgs;};
in
  pkgs.mkShell {
    buildInputs = with pkgs;
      [
        rustToolchain # Rust stable toolchain (cargo, clippy, rustfmt, etc.)
        nixd # Nix language server
        fish # Fish shell
        sops
        age
        ssh-to-age
        ssh-to-pgp
        alejandra # Alejandra Nix formatter
        direnv
      ]
      ++ lib.optionals stdenv.isDarwin [libiconv]; # Add libiconv for macOS

    shellHook = ''
      # Ensure direnv is loaded when entering the shell
      eval "$(direnv hook $SHELL)"
    '';
  }
