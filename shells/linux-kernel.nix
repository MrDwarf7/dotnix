# Mainline Linux Kernel Development Environment - 6.12.17 - 6.13.0
{pkgs ? import <nixpkgs> {}}: let
in
  pkgs.mkShell {
    name = "linux-kernel-dev-env";
    buildInputs = with pkgs; [
      stdenv
      git
      gnumake
      ncurses
      bc
      flex
      bison
      perl
      python3
      elfutils
      pahole
      openssl
      qemu_full
      debootstrap
      gcc
      gdb
      clang_16
      clang-tools_16
      lld_16
      llvmPackages_16.libllvm
    ];
  }
