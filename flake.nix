{
  description = "Dotfiles flake";

  inputs = {
    self.submodules = true;

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    import-tree.url = "github:denful/import-tree";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";

    home-manager.url = "github:nix-community/home-manager?ref=release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    nur.inputs.flake-parts.follows = "flake-parts";

    starship-dracula = {
      url = "github:dracula/starship";
      flake = false;
    };

    rofi-dracula = {
      url = "github:dracula/rofi";
      flake = false;
    };

    sublime-dracula = {
      url = "github:dracula/sublime";
      flake = false;
    };

    opencode-dracula = {
      url = "github:dracula/opencode";
      flake = false;
    };

    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };

    superpowers-skills = {
      url = "github:obra/superpowers";
      flake = false;
    };

    minpac = {
      url = "github:k-takata/minpac";
      flake = false;
    };

    nix-secrets = {
      url = "./nix-secrets";
      flake = false;
    };

    clean-path-vim = {
      url = "github:Guergeiro/clean-path.vim";
      flake = false;
    };
    vim-altscreen = {
      url = "github:fcpg/vim-altscreen";
      flake = false;
    };
    vim-fern = {
      url = "github:lambdalisue/vim-fern";
      flake = false;
    };
    vim-fern-git-status = {
      url = "github:lambdalisue/vim-fern-git-status";
      flake = false;
    };
    vim-fern-hijack = {
      url = "github:lambdalisue/vim-fern-hijack";
      flake = false;
    };
    vim-fern-renderer-nerdfont = {
      url = "github:lambdalisue/vim-fern-renderer-nerdfont";
      flake = false;
    };
    vim-nerdfont = {
      url = "github:lambdalisue/vim-nerdfont";
      flake = false;
    };
    vim-smartpairs = {
      url = "github:gosukiwi/vim-smartpairs";
      flake = false;
    };
    diffconflicts = {
      url = "github:whiteinge/diffconflicts";
      flake = false;
    };
    ddc-source-rg = {
      url = "github:Shougo/ddc-source-rg";
      flake = false;
    };
    ddc-filter-converter_remove_overlap = {
      url = "github:Shougo/ddc-filter-converter_remove_overlap";
      flake = false;
    };
    ddc-source-vsnip = {
      url = "github:uga-rosa/ddc-source-vsnip";
      flake = false;
    };
    ddc-buffer = {
      url = "github:matsui54/ddc-buffer";
      flake = false;
    };
    scalpel = {
      url = "github:wincent/scalpel";
      flake = false;
    };
  };

  outputs =
    inputs:

    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.home-manager.flakeModules.home-manager
        ./home.nix
        (inputs.import-tree [
          ./hosts
          ./modules
          ./shells
        ])
      ];
    };
}
