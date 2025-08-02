{
  description = "Dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-secrets = {
      url = "git+file:./nix-secrets";
      flake = false;
    };

    starship-dracula = {
      url = "github:dracula/starship";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      flake-parts,
      nix-secrets,
      starship-dracula,
      ...
    }:
    let
      secrets = builtins.fromJSON (builtins.readFile nix-secrets);

      # Define forAllSystems to generate Nixpkgs instances for each system
      forAllSystems =
        function:
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

      homeModules =
        pkgs:
        commonModules
        ++ (
          if pkgs.stdenv.isLinux then
            linuxModules
          else if pkgs.stdenv.isDarwin then
            macosModules
          else
            [ ]
        );

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
        pkgs: system: secrets: secretsLocation: sshKeyFiles:
        pkgs.lib.mkMerge [
          {
            sshKeys = generateSshKeyMap secretsLocation sshKeyFiles;
          }
          {
            username = secrets.${system}.username;
            gitEmail = secrets.${system}.gitEmail;
            system = pkgs.system;
            inherit starship-dracula;
          }
        ];
    in
    {
      mkHomeModules = pkgs: system: secrets: secretsLocation: {
        modules = homeModules pkgs;
        extraSpecialArgs = pkgs.lib.mkMerge [
          (createExtraSpecialArgs pkgs system secrets secretsLocation sshKeyFiles)
          {
            standalone = false;
          }
        ];
      };
      homeConfigurations = forAllSystems (
        pkgs:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = homeModules pkgs;
          extraSpecialArgs = pkgs.lib.mkMerge [
            (createExtraSpecialArgs pkgs pkgs.system secrets nix-secrets sshKeyFiles)
            {
              standalone = true;
            }
          ];
        }
      );
    };
}
