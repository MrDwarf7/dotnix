{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options = {
    program.cliMin.enable = lib.mkEnableOption "Enable minimal cli programs";
  };

  config = lib.mkIf config.program.cliMin.enable {
    nixpkgs.overlays = [
      inputs.neovim-nightly-overlay.overlays.default
    ];

    environment.systemPackages = with pkgs; [
      agenix-cli
      bat
      btop
      cachix
      clang
      delta # Better git diff
      disko
      dust # Better du (disk usage) -- if this doesn't work use du-dust
      duf # Disk Usage + File Information tui
      eza # Better `ls`
      fd
      file # File type checker
      fish # Shell
      fzf # Fuzzy finder
      skim # Fzf but written in Rust -- fzf can struggle on older machines
      fzy # Fuzzy finder
      gh # GitHub CLI
      git
      gnupg # GPG / GnuPG
      gping # ping - with GRAPHS!
      hexyl # hex viewer
      jujutsu # Weider, wilder Git alternative
      just # Rust based task runner
      lazygit
      linux-firmware
      lsof # List Of Open Files
      neovim
      ouch # A CLI tool for compress & decompressing files and dir
      procs # Process viewer -- like ps
      tmux
      tokei
      tre-command
      glow
      tlrc # Better `tldr` - short docs for CLI commands
      xh
      llvm
      ripgrep
      sd
      sops
      age
      ssh-to-age
      ssh-to-pgp
      unzip
      vim
      wezterm
      wget
      yazi-unwrapped
      zellij
      zip
      zoxide
      (import ../derivations/moxide.nix {inherit pkgs;})
      (import ../derivations/mox.nix {inherit pkgs;})
      jq
    ];
    programs.nano.enable = false;
  };
}
