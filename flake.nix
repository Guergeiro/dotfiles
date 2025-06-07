{
  description = "Dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-secrets.url = "git+file:./nix-secrets";
  };

  outputs = { self, nixpkgs, home-manager, flake-parts, nix-secrets, ... }:
  let
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ] (system: function nixpkgs.legacyPackages.${system});

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
        ./direnv/default.nix
        ./git/default.nix
        ./gtk/default.nix
        ./librewolf/default.nix
        ./readline/default.nix
        ./starship/default.nix
        ./tmux/default.nix
      ];

      extraSpecialArgs = {
        username = nix-secrets.linux.username;
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
        ./direnv/default.nix
        ./git/default.nix
        ./librewolf/default.nix
        ./readline/default.nix
        ./starship/default.nix
        ./tmux/default.nix
      ];

      extraSpecialArgs = {
        username = nix-secrets.macos.username;
        system = darwinSystem;
      };
    };
  };
}
