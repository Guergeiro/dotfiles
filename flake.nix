{
  description = "Dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    nix-secrets = {
      url = "git+file:./nix-secrets";
      flake = false;
    };

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

    obra-superpowers = {
      url = "github:obra/superpowers";
      flake = false;
    };

    minpac = {
      url = "github:k-takata/minpac";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nur,
      home-manager,
      nix-secrets,
      starship-dracula,
      rofi-dracula,
      sublime-dracula,
      opencode-dracula,
      obra-superpowers,
      minpac,
      ...
    }:
    let
      secrets = builtins.fromJSON (builtins.readFile nix-secrets);

      opencode-plugins = {
        superpowers = obra-superpowers;
      };

      # Define forAllSystems to generate Nixpkgs instances for each system
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-darwin"
        ] (system: function nixpkgs.legacyPackages.${system});

      homeModules = [
        ./home.nix

        ./applications/alacritty.nix
        ./applications/bruno.nix
        ./applications/discord.nix
        ./applications/gimp.nix
        ./applications/keepassxc.nix
        ./applications/librewolf.nix
        ./applications/localsend.nix
        ./applications/mos.nix
        ./applications/rofi.nix
        ./applications/rustdesk.nix
        ./applications/signal.nix
        ./applications/spotify.nix
        ./applications/thunderbird.nix
        ./applications/whatsapp.nix

        ./window-manager/aerospace.nix
        ./window-manager/qtile.nix

        ./cli/ansible.nix
        ./cli/bash.nix
        ./cli/bitwarden.nix
        ./cli/colima.nix
        ./cli/direnv.nix
        ./cli/git.nix
        ./cli/gradle.nix
        ./cli/opencode.nix
        ./cli/readline.nix
        ./cli/ssh.nix
        ./cli/starship.nix
        ./cli/tmux.nix
        ./cli/vim.nix
      ];

      sshKeyFiles = [
        "sign_key.pub"
        "id_ed25519.pub"
      ];

      generateSshKeyMap =
        secretsLocation: filenames:
        builtins.listToAttrs (
          map (name: {
            name = name;
            value = {
              source = "${secretsLocation}/${name}";
              target = "./.ssh/${name}";
              force = true;
            };
          }) filenames
        );

      createExtraSpecialArgs =
        pkgs: system: secrets: secretsLocation: sshKeyFiles: dotfilesDir:
        pkgs.lib.mkMerge [
          {
            sshKeys = generateSshKeyMap secretsLocation sshKeyFiles;
          }
          {
            dotfilesDir = dotfilesDir;
            username = secrets.${system}.username;
            isPersonal = secrets.${system}.personal;
            isWork = secrets.${system}.personal == false;
            envVars = secrets.${system}.environment or { };
            gradleProperties = secrets.${system}.gradle or { };
            system = pkgs.system;
            sshConfig = secrets.${system}.sshConfig;
            gitConfig = secrets.${system}.gitConfig;
            nur = nur.legacyPackages.${system};
            inherit
              starship-dracula
              rofi-dracula
              sublime-dracula
              opencode-dracula
              opencode-plugins
              minpac
              ;
          }
        ];
    in
    {
      mkHomeModules = pkgs: system: secrets: secretsLocation: dotfilesDir: {
        modules = homeModules;
        extraSpecialArgs = pkgs.lib.mkMerge [
          (createExtraSpecialArgs pkgs system secrets secretsLocation sshKeyFiles dotfilesDir)
          {
            standalone = false;
          }
        ];
      };
      homeConfigurations = forAllSystems (
        pkgs:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = homeModules;
          extraSpecialArgs = pkgs.lib.mkMerge [
            (createExtraSpecialArgs pkgs pkgs.system secrets nix-secrets sshKeyFiles self)
            {
              standalone = true;
            }
          ];
        }
      );
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
            ];

            GIT_CONFIG_COUNT = "1";
            GIT_CONFIG_KEY_0 = "core.hooksPath";
            GIT_CONFIG_VALUE_0 = hooksDir;
          };
        }
      );
    };
}
