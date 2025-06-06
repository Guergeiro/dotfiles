{
  description = "Dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, nixpkgs, home-manager, flake-parts, ... }:
  let
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ] (system: function nixpkgs.legacyPackages.${system});

    secrets = import ./secrets.nix;

    linuxSystem = "x86_64-linux";
    darwinSystem = "aarch64-darwin";
  in
  {
    homeConfigurations."breno-linux" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${linuxSystem};

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        ./home.nix
        ./bash/default.nix
        ./git/default.nix
        ./readline/default.nix
        ./starship/default.nix
        ./tmux/default.nix
        ./gtk/default.nix
      ];

      extraSpecialArgs = {
        username = secrets.linuxUsername;
        system = linuxSystem;
      };
    };
    homeConfigurations."breno-macos" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${darwinSystem};

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        ./home.nix
        ./aerospace/default.nix
        ./bash/default.nix
        ./git/default.nix
        ./readline/default.nix
        ./starship/default.nix
        ./tmux/default.nix
      ];

      extraSpecialArgs = {
        username = secrets.macosUsername;
        system = darwinSystem;
      };
    };
  };
}
