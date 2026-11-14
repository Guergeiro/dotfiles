{ host, pkgs, ... }:
let
  enable = host.personal or false;
in
{
  home.packages =
    with pkgs;
    lib.mkIf enable [
      zmk-studio
    ];
}
