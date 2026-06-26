{ pkgs, ... }:
{
  services.darkman = {
    enable = pkgs.stdenv.isLinux;
    settings = {
      lat = 38.74;
      lon = -9.20;
      usegeoclue = false;
    };
  };
}
