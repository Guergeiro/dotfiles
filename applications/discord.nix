{
  pkgs,
  lib,
  host,
  ...
}:
let
  isPersonal = host.personal or false;
  enable = pkgs.stdenv.hostPlatform.isLinux && isPersonal;
in
{
  home.packages =
    with pkgs;
    lib.mkIf enable [
      legcord
    ];
}
