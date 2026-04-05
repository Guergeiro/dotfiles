{ pkgs, rofi-dracula, ... }:
{
  programs.rofi = {
    enable = pkgs.stdenv.isLinux;
    theme = "${rofi-dracula}/theme/config1.rasi";
    font = "FantasqueSansM Nerd Font";
    extraConfig = {
      matching = "fuzzy";
      sort-method = "fzf";
      sort = true;
    };
  };
}
