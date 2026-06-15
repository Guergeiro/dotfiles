{ pkgs, isPersonal, ... }:
let
  enable = pkgs.stdenv.isLinux && isPersonal;
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
