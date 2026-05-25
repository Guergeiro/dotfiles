{
  lib,
  username,
  nur,
  pkgs,
  ...
}:
{
  programs.librewolf = {
    enable = true;
    languagePacks = [
      "en-GB"
      "pt-PT"
    ];
    settings = lib.mkMerge [
      {
        # Reopen windows/tabs
        "browser.startup.page" = 3;
        "privacy.clearOnShutdown.history" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        "browser.toolbars.bookmarks.visibility" = "newtab";
        # We manage extensions via nix
        "extensions.autoDisableScopes" = 0;
        "extensions.update.enabled" = false;
        "extensions.update.autoUpdateDefault" = false;
      }
    ];
    profiles."${username}".extensions = {
      force = true;
      packages = with nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
      ];
      settings = {
        "uBlock0@raymondhill.net" = {
          settings = {
            selectedFilterLists = [
              "user-filters"
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"
              "easylist"
              "easyprivacy"
              "LegitimateURLShortener"
              "adguard-spyware-url"
              "urlhaus-1"
              "curben-phishing"
              "plowe-0"
              "fanboy-cookiemonster"
              "ublock-cookies-easylist"
              "adguard-cookies"
              "ublock-cookies-adguard"
            ];
          };
        };
      };
    };
  };

  # https://wiki.nixos.org/wiki/Default_applications
  xdg.mimeApps.defaultApplications = {
    "default-web-browser" = "librewolf.desktop";
    "text/html" = "librewolf.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
    "x-scheme-handler/about" = "librewolf.desktop";
    "x-scheme-handler/unknown" = "librewolf.desktop";
  };

  home.sessionVariables.DEFAULT_BROWSER = lib.getExe pkgs.librewolf;
}
