{ ... }:
{
  programs.librewolf = {
    enable = true;
    languagePacks = [
      "en-GB"
      "pt-PT"
    ];
    settings = {
      # Reopen windows/tabs
      "browser.startup.page" = 3;
      "privacy.clearOnShutdown.history" = false;
      "privacy.resistFingerprinting" = false;
    };
  };
}
