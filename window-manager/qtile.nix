{
  config,
  pkgs,
  dotfilesDir,
  lib,
  ...
}:
let
  qtileDir = "${dotfilesDir}/window-manager/qtile";
  kanshi_exec = [ "qtile cmd-obj -o cmd -f reconfigure_screens" ];

  output_laptop = {
    criteria = "eDP-1";
    mode = "1920x1200@60";
  };

  output_external_1 = {
    criteria = "HP Inc. HP E27 G4 CNK107263B";
    mode = "1920x1080@60";
  };

  output_external_2 = {
    criteria = "HP Inc. HP E27 G4 CNK107262X";
    mode = "1920x1080@60";
  };
in
{
  home.file.".config/qtile/config.py" = lib.mkIf pkgs.stdenv.isLinux {
    source = config.lib.file.mkOutOfStoreSymlink "${qtileDir}/config.py";
    force = true;
  };

  services.clipcat.enable = pkgs.stdenv.isLinux;
  services.blueman-applet.enable = pkgs.stdenv.isLinux;
  services.kanshi = {
    enable = pkgs.stdenv.isLinux;
    systemdTarget = "";
    settings = [
      {
        profile.name = "undocked";
        profile.exec = kanshi_exec;
        profile.outputs = [
          (lib.mergeAttrs output_laptop { position = "0,0"; })
        ];
      }
      {
        profile.name = "docked";
        profile.exec = kanshi_exec;
        profile.outputs = [
          (lib.mergeAttrs output_laptop { status = "disable"; })
          (lib.mergeAttrs output_external_1 { position = "1920,0"; })
          (lib.mergeAttrs output_external_2 { position = "0,0"; })
        ];
      }
      {
        profile.name = "laptop_monitor";
        profile.exec = kanshi_exec;
        profile.outputs = [
          (lib.mergeAttrs output_laptop { position = "0,1080"; })
          (lib.mergeAttrs output_external_1 { position = "0,0"; })
        ];
      }
    ];
  };

  home.packages =
    with pkgs;
    lib.mkIf pkgs.stdenv.isLinux [
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

  dconf.settings = lib.mkIf pkgs.stdenv.isLinux {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  home.pointerCursor = {
    enable = pkgs.stdenv.isLinux;
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
      enable = pkgs.stdenv.isLinux;
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
    enable = pkgs.stdenv.isLinux;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gnome
    ];
    config = {
      common.default = "*";
      qtile."org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      qtile-wayland = {
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };
}
