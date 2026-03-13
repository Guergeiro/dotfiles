{ rofi-dracula, ... }:
{
  programs.rofi = {
    enable = true;
    theme = "${rofi-dracula}/theme/config1.rasi";
    font = "FantasqueSansM Nerd Font";
    extraConfig = {
      matching = "fuzzy";
      sort-method = "fzf";
      sort = true;
    };
  };
}
