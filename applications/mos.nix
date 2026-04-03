{
  pkgs,
  lib,
  ...
}:
{
  home.packages =
    with pkgs;
    lib.mkIf pkgs.stdenv.isDarwin [
      mos
    ];
}
