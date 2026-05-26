{
  pkgs,
  username,
  system,
  lib,
  standalone,
  ...
}:
let
  dotfilesBaseCmd = "home-manager switch --flake $HOME/Documents/guergeiro/dotfiles";

  dotfilesUpdate = "${dotfilesBaseCmd}/.#${system}";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

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
  xdg.mimeApps.enable = true;

  home.shellAliases = lib.mkIf standalone {
    "dotfiles-update" = dotfilesUpdate;
  };

  targets.darwin.copyApps.enable = pkgs.stdenv.isDarwin;
  targets.darwin.linkApps.enable = false;

  # Packages that I always want to use regardless if the system has it or not
  home.packages = with pkgs; [
    gnused
    coreutils
  ];
}
