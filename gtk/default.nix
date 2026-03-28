{
  pkgs,
  config,
  ...
}:
{
  programs.firefoxpwa = {
    enable = true;

    settings = {
      "firefoxpwa.enableHidingIconBar" = true;
    };

    profiles."01KMTZRFEDWNC2GHD1TN5SZRW5".sites."01KMTZRFEDWNC2GHD1TN5SZRW5" = {
      manifestUrl = "https://open.spotifycdn.com/cdn/generated/manifest-web-player.1609946b.json";
      name = "Spotify";
      url = "https://open.spotify.com/";
      desktopEntry.icon = pkgs.fetchurl {
        url = "https://open.spotifycdn.com/cdn/images/icons/Spotify_1024.31b25879.png";
        sha256 = "sha256-MbJYed49mTS56YqTzohLBdnfngOoAASRJ98rZIhvAFU=";
      };
    };

    profiles."01KMV006FY2SN4QFRX71YSCZBH".sites."01KMV006FY2SN4QFRX71YSCZBH" = {
      manifestUrl = "https://web.whatsapp.com/data/manifest.json";
      name = "WhatsApp";
      url = "https://web.whatsapp.com/";
      desktopEntry.icon = pkgs.fetchurl {
        url = "https://static.whatsapp.net/rsrc.php/yp/r/iBj9rlryvZv.svg";
        sha256 = "sha256-QmNVdkQ5QwVITocMZ8Hlf26P559OdrCJO6ezPoMKUeI=";
      };
    };
  };

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
