{
  pkgs,
  lib,
  ...
}:
{
  home.packages =
    with pkgs;
    lib.mkIf pkgs.stdenv.isLinux [
      thunderbird
    ];
}
