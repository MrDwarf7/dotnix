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

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = ""; # Don't download the darwin deps

    ags.url = "github:aylur/ags";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-yazi-plugins = {
    #   url = "github:lordkekz/nix-yazi-plugins?ref=main";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # TODO: Make this a sub-flake so we don't have like 8+ yazi plugins in input block lol
    yazi-plugins = {
        url = "github:yazi-rs/plugins?ref=main";
        flake = false;
    };

    glow = {
        url = "github:Reledia/glow.yazi";
        flake = false;
    };

    hexyl = {
        url = "github:Reledia/hexyl.yazi";
        flake = false;
    };

    miller = {
        url = "github:Reledia/miller.yazi";
        flake = false;
    };

    rich-preview = {
        url = "github:AnirudhG07/rich-preview.yazi";
        flake = false;
    };

    ouch = {
        url = "github:ndtoan96/ouch.yazi";
        flake = false;
    };

    starship = {
        url = "github:Rolv-Apneseth/starship.yazi";
        flake = false;
    };

    relative-motions = {
        url = "github:dedukun/relative-motions.yazi";
        flake = false;
    };

    eza-preview = {
        url = "github:sharklasers996/eza-preview.yazi";
        flake = false;
    };

    muxbar = {
      url = "github:dlurak/muxbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    retch = {
      url = "github:dlurak/retch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    alejandra.url = "github:kamadorueda/alejandra/3.1.0";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    disko,
    muxbar,
    ags,
    spicetify-nix,
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
      specialArgs = {inherit inputs ags spicetify-nix muxbar disko nixpkgs;};
      modules = [
        ./modules
        ./hosts/nixbook/configuration.nix
        disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager
        {
          environment.systemPackages = [inputs.agenix.packages.x86_64-linux.default];
        }
      ];
    };
    # homeConfigurations."dwarf@nixbook" = inputs.home-manager.lib.homeManagerConfiguration {
    #   extraSpecialArgs = {inherit inputs;}; #outputs = self; };
    #   specialArgs = {inherit inputs;};
    #   modules = [
    #     ./home/dwarf/nixbook.nix
    #   ];
    # };
    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
