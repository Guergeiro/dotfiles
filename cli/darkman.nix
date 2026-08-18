{ pkgs, ... }:
{
  services.darkman = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    settings = {
      lat = 38.74;
      lon = -9.20;
      usegeoclue = false;
    };
  };
}
