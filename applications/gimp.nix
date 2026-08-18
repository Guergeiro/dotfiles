{
  pkgs,
  lib,
  ...
}:
{
  home.packages =
    with pkgs;
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux [
      gimp3
    ];
}
