# Rust
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options = {
    program.languages.rust.enable = lib.mkEnableOption "Enable the Rust programming language";
  };

  config = lib.mkIf config.program.languages.rust.enable {
    nixpkgs.overlays = [
      inputs.rust-overlay.overlays.default
    ];

    environment.systemPackages = with pkgs; [
      # (rust-bin.selectedLatestNightlyWith (toolchain: toolchain.default.override {
      # }))
      (rust-bin.fromRustupToolchainFile ./rust-toolchain.toml)
      rustup
      taplo #toml formatter & lsp
      cargo-watch
      cargo-make
      cargo-deny
      cargo-audit
      cargo-update
      cargo-edit
      cargo-outdated
      cargo-license
      cargo-tarpaulin
      cargo-cross
      cargo-zigbuild
      cargo-nextest
      cargo-spellcheck
      cargo-modules
      cargo-bloat
      cargo-unused-features
      bacon
      evcxr #rust repl
    ];
  };
}
