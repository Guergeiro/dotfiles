{ lib, pkgs, ... }:
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
      }
      # (lib.mkIf (!pkgs.stdenv.isDarwin) {
      #   "widget.gtk.non-native-titlebar-buttons.enabled" = false;
      # })
    ];
  };
}
