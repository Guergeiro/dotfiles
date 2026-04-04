{
  pkgs,
  lib,
  sublime-dracula,
  ...
}:
let
  darwinCopy = pkgs.writeShellScriptBin "copy" ''
    exec pbcopy
  '';
  darwinPaste = pkgs.writeShellScriptBin "paste" ''
    exec pbpaste
  '';

  linuxCopy = pkgs.writeShellScriptBin "copy" ''
    if [ -n "$WAYLAND_DISPLAY" ]; then
      exec ${pkgs.wl-clipboard}/bin/wl-copy
    else
      exec ${pkgs.xclip}/bin/xclip -i -selection clipboard
    fi
  '';
  linuxPaste = pkgs.writeShellScriptBin "paste" ''
    if [ -n "$WAYLAND_DISPLAY" ]; then
      exec ${pkgs.wl-clipboard}/bin/wl-paste
    else
      exec ${pkgs.xclip}/bin/xclip -o -selection clipboard
    fi
  '';
in
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoreboth" ];
    shellOptions = [
      # append to the history file, don't overwrite it
      "histappend"
      # update the values of LINES and COLUMNS.
      "checkwinsize"
      # Removes the need of using cd
      "autocd"
      # Automatically tries it's best to correct misspell
      "cdspell"
    ];
    initExtra = ''
      function docker-compose() {
        if [ "$1" = "up" ]; then
          shift
          command ${pkgs.docker}/bin/docker compose up --remove-orphans --build "$@"
        else
          command ${pkgs.docker}/bin/docker compose "$@"
        fi
      }

      function cd() {
        local dir="$@"
        builtin cd $dir && ls -A --color=auto
      }

      # Check if internet is working
      function ping() {
        if [ "$#" -ne 0 ]; then
          command ping "$@"
        else
          command ping "www.brenosalles.com"
        fi
      }

      eval "$(${pkgs.openssh}/bin/ssh-agent -s)" > /dev/null
      ${pkgs.openssh}/bin/ssh-add ~/.ssh/id_ed25519 2> /dev/null
    '';
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
    };
    themes = {
      Dracula = {
        src = sublime-dracula;
        file = "Dracula.tmTheme";
      };
    };
    extraPackages = with pkgs.bat-extras; [
      batman
      batdiff
    ];
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--hidden"
      "--color=auto"
      "--smart-case"
    ];
  };

  home.packages = [
    pkgs.openssh
    pkgs.xclip
    pkgs.wl-clipboard
    pkgs.trash-cli

    # Create a new copy/paste command that allows too feed/read content directly to/from clipboard
    (if pkgs.stdenv.isDarwin then darwinCopy else linuxCopy)
    (if pkgs.stdenv.isDarwin then darwinPaste else linuxPaste)
  ];

  home.shellAliases = {
    # You remember Vi? It's just faster to type
    vi = "${pkgs.neovim}/bin/nvim";
    vim = "${pkgs.neovim}/bin/nvim";
    # Force tmux UTF-8
    tmux = "${pkgs.tmux}/bin/tmux -u";
    # Sometimes I forget I'm not in VIM, but still want to quit :>
    ":q" = "exit";
    # Fuck Python2... Sorry :(
    python = "python3";
    pip = "pip3";
    # Security stuff
    del = "${pkgs.trash-cli}/bin/trash";
    rm = "${pkgs.coreutils}/bin/echo Use \"del\", or the full path i.e. \"/bin/rm\"";
    mv = "${pkgs.coreutils}/bin/mv -i";
    cp = "${pkgs.coreutils}/bin/cp -i";
    ln = "${pkgs.coreutils}/bin/ln -i";
    # Recursively create directories
    mkdir = "${pkgs.coreutils}/bin/mkdir -pv";

    # Some more ls aliases
    ll = "${pkgs.coreutils}/bin/ls -alhF --color=auto";
    la = "${pkgs.coreutils}/bin/ls -hA --color=auto";
    l = "${pkgs.coreutils}/bin/ls -CF --color=auto";
    ls = "${pkgs.coreutils}/bin/ls --color=auto";

    # Ripgrep rules for me!
    grep = "${pkgs.ripgrep}/bin/rg";
    fgrep = "${pkgs.ripgrep}/bin/rg -F";
    egrep = "${pkgs.ripgrep}/bin/rg -E";

    # Bat is awesome
    cat = "${pkgs.bat}/bin/bat";
    man = "${pkgs.bat-extras.batman}/bin/batman";
    diff = "${pkgs.bat-extras.batdiff}/bin/batdiff";
  };
}
