{
  description = "Dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-secrets.url = "git+file:./nix-secrets";

    starship-dracula = {
      url = "github:dracula/starship";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, flake-parts, nix-secrets, starship-dracula, ... }:
  let
    # Define forAllSystems to generate Nixpkgs instances for each system
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ] (system: function nixpkgs.legacyPackages.${system});

    # Common modules for both Linux and macOS (where applicable)
    commonModules = [
      ./home.nix
      ./alacritty/default.nix
      ./bash/default.nix
      ./direnv/default.nix
      ./git/default.nix
      ./gradle/default.nix
      ./librewolf/default.nix
      ./readline/default.nix
      ./ssh/default.nix
      ./starship/default.nix
      ./tmux/default.nix
      ./vim/default.nix
    ];

    linuxModules = [
      ./awesome/default.nix
      ./gtk/default.nix
    ];

    macosModules = [
      ./aerospace/default.nix
    ];

    homeModules = pkgs: commonModules ++
          (if pkgs.stdenv.isLinux then
            linuxModules
          else if pkgs.stdenv.isDarwin then
            macosModules
          else []);
  in
  {
    mkHomeModules = pkgs: {
      extraSpecialArgs = {
        standalone = false;
        inherit starship-dracula;
      };
      modules = homeModules pkgs;
    };
    homeConfigurations = forAllSystems (pkgs:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = homeModules pkgs;
        extraSpecialArgs = {
          username = nix-secrets.${pkgs.system}.username;
          gitEmail = nix-secrets.${pkgs.system}.gitEmail;
          system = pkgs.system;
          standalone = true;
          inherit starship-dracula;
        };
      }
    );
  };
}
