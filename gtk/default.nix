{ pkgs, config, ... }:
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  home.pointerCursor = {
    enable = true;
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 16;
  };
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    gtk3.bookmarks = [
      "file:///${config.home.homeDirectory}/Documents"
      "file:///${config.home.homeDirectory}/Music"
      "file:///${config.home.homeDirectory}/Pictures"
      "file:///${config.home.homeDirectory}/Videos"
      "file:///${config.home.homeDirectory}/Downloads"
    ];
  };
}
