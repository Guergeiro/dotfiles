{
  inputs,
  self,
  ...
}:
{
  flake.homeModules.home =
    {
      config,
      pkgs,
      hostname,
      lib,
      host,
      standalone,
      osConfig,
      ...
    }:
    let
      inherit (host) username;

      dotfilesBaseCmd = "home-manager switch --flake $HOME/Documents/guergeiro/dotfiles";
      dotfilesUpdate = "${dotfilesBaseCmd}/.#${hostname}";

      homeDirectory =
        if !standalone then
          osConfig.users.users.${username}.home
        else
          (if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}");
    in
    {
      imports = [
        inputs.agenix.homeManagerModules.default

        self.homeModules.alacritty
        self.homeModules.bruno
        self.homeModules.discord
        self.homeModules.gimp
        self.homeModules.keepassxc
        self.homeModules.librewolf
        self.homeModules.localsend
        self.homeModules.mos
        self.homeModules.obs
        self.homeModules.rofi
        self.homeModules.signal
        self.homeModules.spotify
        self.homeModules.thunderbird
        self.homeModules.whatsapp
        self.homeModules.zmk

        self.homeModules.aerospace
        self.homeModules.qtile

        self.homeModules.ansible
        self.homeModules.aws
        self.homeModules.bash
        self.homeModules.colima
        self.homeModules.darkman
        self.homeModules.direnv
        self.homeModules.git
        self.homeModules.gomi
        self.homeModules.gradle
        self.homeModules.karabiner
        self.homeModules.opencode
        self.homeModules.readline
        self.homeModules.ssh
        self.homeModules.starship
        self.homeModules.tmux
        self.homeModules.vim
      ];

      # Home Manager needs a bit of information about you and the paths it should
      # manage.
      home.username = username;
      home.homeDirectory = homeDirectory;

      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      home.stateVersion = "25.05"; # Please read the comment before changing.

      # Home Manager can also manage your environment variables through
      # 'home.sessionVariables'. These will be explicitly sourced when using a
      # shell provided by Home Manager. If you don't want to manage your shell
      # through Home Manager then you have to manually source 'hm-session-vars.sh'
      # located at either
      #
      #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  /etc/profiles/per-user/breno/etc/profile.d/hm-session-vars.sh
      #
      home.sessionVariables = {
      };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      home.preferXdgDirectories = true;
      xdg.mimeApps.enable = pkgs.stdenv.hostPlatform.isLinux;

      home.shellAliases = lib.mkIf standalone {
        "dotfiles-update" = dotfilesUpdate;
      };

      targets.darwin.copyApps.enable = pkgs.stdenv.hostPlatform.isDarwin;
      targets.darwin.linkApps.enable = false;

      # Packages that I always want to use regardless if the system has it or not
      home.packages = with pkgs; [
        gnused
        coreutils
      ];

      age.identityPaths = [
        "${config.home.homeDirectory}/Documents/guergeiro/iac/nix-secrets/root"
        "${config.home.homeDirectory}/.ssh/id_ed25519"
      ];

      age.secrets = lib.mkMerge [
        (lib.genAttrs [ "id_ed25519" "sign_key" ] (name: {
          file = "${inputs.nix-secrets}/${name}.age";
          path = "${config.home.homeDirectory}/.ssh/${name}";
        }))
        {
          "${hostname}/env".file = "${inputs.nix-secrets}/${hostname}/env.age";
        }
      ];
    };
}
