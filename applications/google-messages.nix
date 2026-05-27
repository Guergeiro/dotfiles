{
  pkgs,
  lib,
  isPersonal,
  ...
}:
let
  browser = lib.getExe pkgs.ungoogled-chromium;
  enable = pkgs.stdenv.isLinux && isPersonal;
in
{
  xdg.desktopEntries.google-messages = lib.mkIf enable {
    name = "Google Messages";
    exec = "${browser} --app=https://messages.google.com/web/";
    icon = pkgs.fetchurl {
      url = "https://ssl.gstatic.com/android-messages-web/images/2022.3/2x/messages_2022_96dp.png";
      sha256 = "sha256-g9pMnvj9FJiVqXCbbIslzBAG9L+nIgRaRHEmtmEEGQE=";
    };
  };

  home.packages = lib.optionals enable [ pkgs.ungoogled-chromium ];
}
