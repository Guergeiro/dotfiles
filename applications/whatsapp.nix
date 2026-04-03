{
  pkgs,
  config,
  lib,
  isPersonal,
  ...
}:
let
  browser = lib.getExe pkgs.ungoogled-chromium;
  enable = pkgs.stdenv.isLinux && isPersonal;
in
{
  xdg.desktopEntries.whatsapp = lib.mkIf enable {
    name = "WhatsApp";
    exec = "${browser} --app=https://web.whatsapp.com/";
  };

  programs.chromium = {
    enable = enable;
    package = pkgs.ungoogled-chromium;
  };
}
