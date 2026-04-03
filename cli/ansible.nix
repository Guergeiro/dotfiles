{
  pkgs,
  lib,
  isPersonal,
  ...
}:
{
  home.packages = lib.mkIf isPersonal [
    pkgs.ansible
    pkgs.python3Packages.passlib
  ];
}
