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
      ansible
      python3Packages.passlib
    ];
}
