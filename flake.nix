{
  description = "Dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }: {
    homeManagerModules.default = {
      config,
      pkgs,
      ...
    }: {
      home.shellAliases = {
        foo = "echo bar";
      };
    };
  };
}
