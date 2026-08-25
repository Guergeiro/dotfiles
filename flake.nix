{
  description = "Dotfiles flake";

  inputs = {
    self.submodules = true;

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    systems.url = "github:nix-systems/default";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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

    minpac = {
      url = "github:k-takata/minpac";
      flake = false;
    };

    nix-secrets = {
      url = "./nix-secrets";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      nur,
      home-manager,
      starship-dracula,
      rofi-dracula,
      sublime-dracula,
      opencode-dracula,
      mattpocock-skills,
      minpac,
      nix-secrets,
      ...
    }:
    let
      hosts = builtins.fromJSON (builtins.readFile "${nix-secrets}/hosts.json");

      opencode-skills = {
        mattpocock = mattpocock-skills;
      };

      forAllSystems =
        function: nixpkgs.lib.genAttrs (import systems) (system: function nixpkgs.legacyPackages.${system});

      homeModules = [
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
        ./applications/rustdesk.nix
        ./applications/signal.nix
        ./applications/spotify.nix
        ./applications/thunderbird.nix
        ./applications/whatsapp.nix

        ./window-manager/aerospace.nix
        ./window-manager/qtile.nix

        ./cli/ansible.nix
        ./cli/bash.nix
        ./cli/colima.nix
        ./cli/darkman.nix
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
        "sign_key"
        "sign_key.pub"
        "id_ed25519"
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
        pkgs: hostname: hosts: secretsLocation: sshKeyFiles: dotfilesDir:
        pkgs.lib.mkMerge [
          {
            sshKeys = generateSshKeyMap secretsLocation sshKeyFiles;
          }
          {
            dotfilesDir = dotfilesDir;
            username = hosts.${hostname}.username;
            isPersonal = hosts.${hostname}.personal;
            isWork = hosts.${hostname}.personal == false;
            envVars = hosts.${hostname}.environment or { };
            gradleProperties = hosts.${hostname}.gradle or { };
            sshConfig = hosts.${hostname}.sshConfig or [ ];
            gitConfig = hosts.${hostname}.gitConfig or [ ];
            nur = nur.legacyPackages.${pkgs.stdenv.hostPlatform.system};
            inherit
              starship-dracula
              rofi-dracula
              sublime-dracula
              opencode-dracula
              opencode-skills
              minpac
              ;
          }
        ];
    in
    {
      mkHomeModules = pkgs: hostname: hosts: secretsLocation: dotfilesDir: {
        modules = homeModules;
        extraSpecialArgs = pkgs.lib.mkMerge [
          (createExtraSpecialArgs pkgs hostname hosts secretsLocation sshKeyFiles dotfilesDir)
          {
            standalone = false;
          }
        ];
      };
      homeConfigurations = builtins.mapAttrs (
        hostname:
        let
          pkgs = nixpkgs.legacyPackages.${hosts.${hostname}.system};
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = homeModules;
          extraSpecialArgs = pkgs.lib.mkMerge [
            (createExtraSpecialArgs pkgs hostname hosts nix-secrets sshKeyFiles self)
            {
              standalone = true;
            }
          ];
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
            ];

            GIT_CONFIG_COUNT = "1";
            GIT_CONFIG_KEY_0 = "core.hooksPath";
            GIT_CONFIG_VALUE_0 = hooksDir;
          };
        }
      );
    };
}
