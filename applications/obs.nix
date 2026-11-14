{ pkgs, host, ... }:
let
  isPersonal = host.personal or false;
  enable = pkgs.stdenv.hostPlatform.isLinux && isPersonal;
in
{
  programs.obs-studio = {
    enable = enable;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
}
