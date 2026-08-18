{
  pkgs,
  config,
  lib,
  isPersonal,
  ...
}:
let
  enable = pkgs.stdenv.hostPlatform.isLinux && isPersonal;
in
{
  home.packages =
    with pkgs;
    lib.mkIf enable [
      rustdesk
    ];
}
