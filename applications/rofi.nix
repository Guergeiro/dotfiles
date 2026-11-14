{ pkgs, inputs, ... }:
{
  programs.rofi = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    theme = "${inputs.rofi-dracula}/theme/config1.rasi";
    font = "FantasqueSansM Nerd Font";
    extraConfig = {
      matching = "fuzzy";
      sort-method = "fzf";
      sort = true;
    };
  };
}
