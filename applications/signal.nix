{
  pkgs,
  lib,
  isPersonal,
  ...
}:
{
  home.packages =
    with pkgs;
    lib.mkIf isPersonal [
      signal-desktop
    ];
}
