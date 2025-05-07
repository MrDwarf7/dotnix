{
  pkgs,
  lib,
  config,
  # inputs,
  ...
}: {
  options = {
    program.cliDev.enable = lib.mkEnableOption "Enable the CLI development programs";
  };

  config = lib.mkIf config.program.cliDev.enable {
    environment.systemPackages = with pkgs; [
      alejandra
      bc
      bison
      # clang_16
      clang_multi
      # clang-tools_16
      cmake
      # debootstrap
      elfutils
      figma-linux
      # figma-agent
      flex
      gcc
      gdb
      gh
      git
      git
      gnumake
      libclang
      # lld_16
      # llvmPackages_16.libllvm
      # makeninja
      meson
      # msbuild
      # mono
      ncurses
      ninja
      nixd
      nil
      openssl
      omnix
      # pahole
      perl
      python3
      # qemu_full
      stdenv
      tridactyl-native
      zed-editor
      # zlib
    ];
  };
}
