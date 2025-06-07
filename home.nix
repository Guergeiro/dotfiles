{ config, pkgs, username, system, lib, ... }:
let
  dotfilesBaseCmd = "home-manager switch --flake $HOME/Documents/guergeiro/dotfiles";
  dotfilesFlake = if system == "aarch64-darwin" || system == "x86_64-darwin"
    then "breno-macos"
    else "breno-linux";

  dotfilesUpdate = "${dotfilesBaseCmd}/.#${dotfilesFlake}";

  browser = lib.getExe pkgs.librewolf;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = if system == "aarch64-darwin" || system == "x86_64-darwin"
    then "/Users/${username}"
    else "/home/${username}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

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
  home.shellAliases = {
    "dotfiles-update" = dotfilesUpdate;
    "dotfiles-upgrade" = "nix flake update --flake $HOME/Documents/guergeiro/dotfiles";
    # You remember Vi? It's just faster to type
    vi = "${pkgs.neovim}/bin/nvim";
    vim = "${pkgs.neovim}/bin/nvim";
    # Force tmux UTF-8
    tmux="${pkgs.tmux}/bin/tmux -u";
    # Sometimes I forget I'm not in VIM, but still want to quit :>
    ":q"="exit";
    # Fuck Python2... Sorry :(
    python="python3"; pip="pip3";
    # Security stuff
    del="${pkgs.trash-cli}/bin/trash";
    rm="${pkgs.coreutils}/bin/echo Use \"del\", or the full path i.e. \"/bin/rm\"";
    mv="${pkgs.coreutils}/bin/mv -i";
    cp="${pkgs.coreutils}/bin/cp -i";
    ln="${pkgs.coreutils}/bin/ln -i";
    # Recursively create directories
    mkdir="${pkgs.coreutils}/bin/mkdir -pv";

    # Some more ls aliases
    ll="${pkgs.coreutils}/bin/ls -alhF --color=auto";
    la="${pkgs.coreutils}/bin/ls -hA --color=auto";
    l="${pkgs.coreutils}/bin/ls -CF --color=auto";
    ls="${pkgs.coreutils}/bin/ls --color=auto";

    # Ripgrep rules for me!
    grep="${pkgs.ripgrep}/bin/rg --hidden --color=auto";
    fgrep="${pkgs.ripgrep}/bin/rg -F --color=auto";
    egrep="${pkgs.ripgrep}/bin/rg -E --color=auto";

    # Bat is awesome
    cat="${pkgs.bat}/bin/bat";
  };

  # I still want to manage Vim manually as it changes frequently
  home.activation.stow-vim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.stow}/bin/stow --target ${config.home.homeDirectory} --stow vim --dir ${config.home.homeDirectory}/Documents/guergeiro/dotfiles
  '';

  home.activation.stow-awesome = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.stow}/bin/stow --target ${config.home.homeDirectory} --stow awesome --dir ${config.home.homeDirectory}/Documents/guergeiro/dotfiles
  '';

  xdg.desktopEntries.whatsapp = {
    name = "WhatsApp";
    exec = "${browser} --kiosk --new-window https://web.whatsapp.com/";
  };
}
