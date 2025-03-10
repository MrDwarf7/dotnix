{
  inputs,
  pkgs,
  ...
}: {
  imports = [
  ];

  environment.systemPackages = with pkgs; [
    inputs.alejandra.defaultPackage.${pkgs.system} # x86_64-linux
    docker
    nmap
    # bash
    # docker
    # nmap
    # pkgs.rust-bin.nightly.latest.default
    age
    aria # Download CLI tool??
    bat # Better cat
    btop # Better top
    cacert
    cachix # Nix
    clang
    cava
    chafa
    cmatrix # Matrix screensaver
    delta # Better git diff
    figlet
    disko # Nix
    dust # Better du (disk usage) -- if this doesn't work use du-dust
    duf # Disk Usage + File Information tui
    eza # Better `ls`
    fd # Better `find`
    file # File type checker
    fish # Shell
    fzf # Fuzzy finder
    skim # Fzf but written in Rust -- fzf can struggle on older machines
    fzy # Fuzzy finder
    gh # GitHub CLI
    git # Git
    git-ignore # Generate .gitignore files using gitignore.io
    gitleaks # Scan your git repos for secrets
    git-secrets # scans for prohib patterns in git repos
    gping # ping - with GRAPHS!
    hexyl # hex viewer
    just # Rust based task runner
    license-generator # Generate LICENSE files
    lsof # List Of Open Files
    monolith # Save web pages as single files
    macchina # Neofetch alternative in Rust
    # mcfly # Terminal history -- replaces ctrl-r
    fastfetch # Neofetch like tool -- Written in C
    noti # Trigger notifications when a process completes
    ouch # A CLI tool for compress & decompressing files and dir
    # pandoc # Document converter
    # pass-git-helper # git gred helper - using `pass` as data store
    pipes-rs # It's literally pipes
    process-compose # Process scheduler and orch.
    procs # Process viewer -- like ps
    progress # Monitors all kinds of file manipulations (cp, mv, dd, ...)
    rewrk # HTTP benchmarking tool
    rsclock # Rust -- It's a tui clock
    tokei # Count your code LOC (Lines of code), quickly
    # topgrade # Upgrade everything
    trash-cli # CLI interface for FreeDesktop.org Trash folder/spec
    tre-command # Better `tree`
    glow # Markdown reader
    tlrc # Better `tldr` - short docs for CLI commands
    upx # Ultimate Packer for eXecutables - compresses programs and libraries by roughly 50-70%
    viu # Image viewer for the terminal
    wrk2 # HTTP benchmarking tool - focusing on solving Coordinated Omission
    xh # Better curl/wget + jq + speedtest
    # speedtest # Speedtest CLI - kinda buggy on cli/nixos
    inputs.neovim-nightly-overlay.packages.${pkgs.system}.default
    llvm
    nh # NixOS helper CLI ( similar to gh )
    nix-ld # NixOS linker for 'normal' binaries
    openssl
    parted # Disk partitioning tool
    ripgrep # Better grep
    # rustup # Rust
    sd # Better sed
    tmux # bro it's tmux?!??? - Terminal multiplexer
    # tree
    unzip
    vim # bro it's vim?!??? - Text editor
    wezterm # Terminal emulator
    wget # Download files
    xclip # Clipboard manager
    yazi # Better ranger/vifm alternative
    zellij # Better tmux alternative
    zip # Compress files
    zoxide # Better cd

    #### Installed via Home-Manager (also)
    # fastfetch
    # fish
    # jq
    # lazygit
    # nerdfonts
    # nh
    # wezterm
    # yazi
    # zoxide
  ];
}
