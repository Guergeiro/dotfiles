{
  config,
  pkgs,
  dotfilesDir,
  lib,
  ...
}:
let
  qtileDir = "${dotfilesDir}/window-manager/qtile";
in
lib.mkIf pkgs.stdenv.isLinux {
  home.file.".config/qtile/config.py" = {
    source = config.lib.file.mkOutOfStoreSymlink "${qtileDir}/config.py";
    force = true;
  };

  services.clipcat.enable = true;
  services.blueman-applet.enable = true;
  home.packages = with pkgs; [
    python3Packages.dbus-fast
    python3Packages.iwlib
    python3Packages.pulsectl-asyncio
    python3Packages.xdg

    pavucontrol
    xfce4-taskmanager
    xfce4-screenshooter
    xfce4-power-manager
    xfce4-settings
  ];

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
  gtk =
    let
      theme = {
        name = "Dracula";
        package = pkgs.dracula-theme;
      };
    in
    {
      enable = true;
      cursorTheme = {
        name = "Dracula-cursors";
        package = pkgs.dracula-theme;
      };
      iconTheme = {
        name = "Dracula";
        package = pkgs.dracula-icon-theme;
      };
      theme = theme;
      gtk4.theme = theme;
      gtk3.bookmarks = [
        "file:///${config.home.homeDirectory}/Documents"
        "file:///${config.home.homeDirectory}/Music"
        "file:///${config.home.homeDirectory}/Pictures"
        "file:///${config.home.homeDirectory}/Videos"
        "file:///${config.home.homeDirectory}/Downloads"
      ];
    };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gnome
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };

      qtile = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };

      qtile-wayland = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };
}
