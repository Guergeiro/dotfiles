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

  launchd.agents.mos = {
    enable = pkgs.stdenv.isDarwin;
    config = {
      Program = "${pkgs.mos}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace";
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/mos.log";
      StandardErrorPath = "/tmp/mos.err.log";
    };
  };
}
