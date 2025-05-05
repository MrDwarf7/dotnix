# For using the 'nix repl'
# run
# nix repl
# then
# :l <nixpkgs>
# This will 'load' the nixpkgs into the repl
# then you can use builtins.<TAB> to see all the builtins functions etc.
{
  description = ''
    A flake for my NixOS configuration.

    dwarf@nixbook -- MacbBook Pro 12,1 (Early 2015)
  '';

  outputs = inputs @ {
    self,
    nixpkgs,
    # disko,
    # ags,
    # spicetify-nix,
    ...
  }: let
    args = {
      inherit self;
      # inherit (inputs) outputs;
      inherit (nixpkgs) lib;
      pkgs = import nixpkgs {};
    };
    lib = import ./lib args;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # user = builtins.getEnv "USER";
    # hostname = builtins.readFile "/etc/hostname";
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations.nixbook = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs nixpkgs lib;};
      modules = [
        ./modules
        ./hosts/nixbook/configuration.nix
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager
      ];
    };
    # homeConfigurations."dwarf@nixbook" = inputs.home-manager.lib.homeManagerConfiguration {
    #   extraSpecialArgs = {inherit inputs;}; #outputs = self; };
    #   specialArgs = {inherit inputs;};
    #   modules = [
    #     ./home/dwarf/nixbook.nix
    #   ];
    # };
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forAllSystems (system: let
        pkgs = import nixpkgs {
            inherit system;
            overlays = [ inputs.rust-overlay.overlays.default ];
        };
        rustToolchain = pkgs.rust-bin.nightly.latest.default;
        alejandra = pkgs.alejandra;
        agenix = pkgs.agenix;
    in {
          default = pkgs.mkShell {
          name = "devShell-${system}";
          description = "Development shell for NixOS configuration";
          packages = with pkgs; [
          agenix-cli
          rustToolchain
          nixd # Nix language server
          fish # Fish shell
          sops
          age
          ssh-to-age
          ssh-to-pgp
          alejandra # Alejandra Nix formatter
          direnv
        ];
      };
    });
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    # agenix.url = "github:ryantm/agenix";
    # agenix.inputs.nixpkgs.follows = "nixpkgs";
    # agenix.inputs.darwin.follows = ""; # Don't download the darwin deps

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    # access the package as inputs.omnix.packages.${pkgs.system}.default.
    omnix.url = "github:juspay/omnix";

    # Make this a sub-flake so we don't have like 8+ yazi plugins in input block lol
    ##### TODO: START: yazi-plugins
    yazi-plugins.url = "github:yazi-rs/plugins?ref=main";
    yazi-plugins.flake = false;

    glow.url = "github:Reledia/glow.yazi";
    glow.flake = false;

    hexyl.url = "github:Reledia/hexyl.yazi";
    hexyl.flake = false;

    miller.url = "github:Reledia/miller.yazi";
    miller.flake = false;

    rich-preview.url = "github:AnirudhG07/rich-preview.yazi";
    rich-preview.flake = false;

    ouch.url = "github:ndtoan96/ouch.yazi";
    ouch.flake = false;

    starship.url = "github:Rolv-Apneseth/starship.yazi";
    starship.flake = false;

    relative-motions.url = "github:dedukun/relative-motions.yazi";
    relative-motions.flake = false;

    eza-preview.url = "github:sharklasers996/eza-preview.yazi";
    eza-preview.flake = false;
    ##### TODO: START: yazi-plugins

    ags.url = "github:aylur/ags";

    muxbar.url = "github:dlurak/muxbar";
    muxbar.inputs.nixpkgs.follows = "nixpkgs";

    retch.url = "github:dlurak/retch";
    retch.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    alejandra.url = "github:kamadorueda/alejandra/3.1.0";
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    # TODO: Change to use fenix
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs"; # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure to have it up to date or simply don't specify the nixpkgs input

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
}
