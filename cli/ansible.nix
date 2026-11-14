{
  pkgs,
  lib,
  host,
  ...
}:
let
  isPersonal = host.personal or false;
in
{
  home.packages =
    with pkgs;
    lib.mkIf isPersonal [
      ansible
      python3Packages.passlib
    ];
}
