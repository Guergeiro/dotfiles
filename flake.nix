{
  description = "Dotfiles flake";

  inputs = {
    self.submodules = true;

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    systems.url = "github:nix-systems/default";

    home-manager.url = "github:nix-community/home-manager?ref=release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

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
    {
      nixpkgs,
      nixpkgs-darwin,
      systems,
      agenix,
      home-manager,
      nix-secrets,
      ...
    }@inputs:
    let
      hosts = builtins.fromJSON (builtins.readFile "${nix-secrets}/hosts.json");

      forAllSystems =
        function:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          let
            pkgs =
              if builtins.match ".*-darwin" system != null then
                nixpkgs-darwin.legacyPackages.${system}
              else
                nixpkgs.legacyPackages.${system};
          in
          function pkgs
        );

      homeModules = [
        agenix.homeManagerModules.default
        ./home.nix

        ./applications/alacritty.nix
        ./applications/bruno.nix
        ./applications/discord.nix
        ./applications/gimp.nix
        ./applications/google-messages.nix
        ./applications/keepassxc.nix
        ./applications/librewolf.nix
        ./applications/localsend.nix
        ./applications/mos.nix
        ./applications/obs.nix
        ./applications/rofi.nix
        ./applications/signal.nix
        ./applications/spotify.nix
        ./applications/thunderbird.nix
        ./applications/whatsapp.nix

        ./window-manager/aerospace.nix
        ./window-manager/qtile.nix

        ./cli/ansible.nix
        ./cli/aws.nix
        ./cli/bash.nix
        ./cli/colima.nix
        ./cli/darkman.nix
        ./cli/direnv.nix
        ./cli/git.nix
        ./cli/gomi.nix
        ./cli/gradle.nix
        ./cli/karabiner.nix
        ./cli/opencode.nix
        ./cli/readline.nix
        ./cli/ssh.nix
        ./cli/starship.nix
        ./cli/tmux.nix
        ./cli/vim.nix
      ];

      createExtraSpecialArgs =
        hostname: standalone:
        let
          host = builtins.fromJSON (builtins.readFile "${nix-secrets}/${hostname}/host.json");
        in
        {
          inherit
            inputs
            hostname
            host
            standalone
            ;
        };
    in
    {
      mkHomeModules = pkgs: hostname: standalone: {
        modules = homeModules;
        extraSpecialArgs = pkgs.lib.mkMerge [
          (createExtraSpecialArgs hostname standalone)
        ];
      };
      homeConfigurations = map (
        hostname:
        let
          host = builtins.fromJSON (builtins.readFile "${nix-secrets}/${hostname}/host.json");
          pkgs = nixpkgs.legacyPackages.${host.system};

          homeCfg = inputs.self.mkHomeModules pkgs hostname true;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = homeCfg.modules;
          extraSpecialArgs = homeCfg.extraSpecialArgs;
        }
      ) hosts;
      devShells = forAllSystems (
        pkgs:
        let
          hookScripts = {
            pre-commit = pkgs.writeShellScript "pre-commit" ''
              format_staged_nix_files() {
                files=$(${pkgs.git}/bin/git diff --cached --name-only --diff-filter=ACMR -- '*.nix')
                [ -z "$files" ] && return 0
                ${pkgs.coreutils}/bin/echo "$files" | ${pkgs.findutils}/bin/xargs ${pkgs.nixfmt}/bin/nixfmt
                ${pkgs.coreutils}/bin/echo "$files" | ${pkgs.findutils}/bin/xargs ${pkgs.git}/bin/git add
              }
              format_staged_nix_files
            '';
            post-commit = pkgs.writeShellScript "post-commit" ''
              exec ${pkgs.git}/bin/git update-index -g
            '';
          };
          hooksDir = pkgs.linkFarm "git-hooks" (
            pkgs.lib.mapAttrsToList (name: path: {
              inherit name path;
            }) hookScripts
          );
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nixfmt
              nixd
              git-crypt
              agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];

            GIT_CONFIG_COUNT = "1";
            GIT_CONFIG_KEY_0 = "core.hooksPath";
            GIT_CONFIG_VALUE_0 = hooksDir;
          };
        }
      );
    };
}
