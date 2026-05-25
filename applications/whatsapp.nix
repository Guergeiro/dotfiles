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
  xdg.desktopEntries.whatsapp = lib.mkIf enable {
    name = "WhatsApp";
    exec = "${browser} --app=https://web.whatsapp.com/";
    icon = pkgs.fetchurl {
      url = "https://static.whatsapp.net/rsrc.php/yp/r/iBj9rlryvZv.svg";
      sha256 = "sha256-QmNVdkQ5QwVITocMZ8Hlf26P559OdrCJO6ezPoMKUeI=";
    };
  };

  programs.chromium = {
    enable = enable;
    package = pkgs.ungoogled-chromium;
  };
}
