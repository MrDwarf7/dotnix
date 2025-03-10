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

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    alejandra.url = "github:kamadorueda/alejandra/3.1.0";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    disko,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
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

    nixosConfigurations = {
      nixbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          ./hosts/nixbook/default.nix
        ];
      };
    };
    homeConfigurations = let
      system = "x86_64-linux";
      pkgs = import nixpkgs {inherit system;};
    in {
      "dwarf@nixbook" = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        extraSpecialArgs = {inherit pkgs system inputs;}; #outputs = self; };
        modules = [
          ./home/dwarf/nixbook.nix
        ];
      };
    };
    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
