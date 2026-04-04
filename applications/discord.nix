{
  pkgs,
  config,
  lib,
  isPersonal,
  ...
}:
let
  enable = pkgs.stdenv.isLinux && isPersonal;
in
{
  home.packages =
    with pkgs;
    lib.mkIf enable [
      legcord
    ];
}
