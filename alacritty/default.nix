{ pkgs, ... }:
let
  fontFamily = "FantasqueSansM Nerd Font";
  style = "Bold";
in
{
  programs.alacritty = {
    enable = true;
    theme = "dracula_plus";
    settings = {
      terminal.shell = "${pkgs.bashInteractive}/bin/bash";
      cursor.style.blinking = "Always";
      font = {
        size = 14;
        bold = {
          family = fontFamily;
          style = style;
        };
        bold_italic = {
          family = fontFamily;
          style = style;
        };
        italic = {
          family = fontFamily;
          style = style;
        };
        normal = {
          family = fontFamily;
          style = style;
        };
      };
      mouse.hide_when_typing = true;
      window = {
        dynamic_padding = true;
        dynamic_title = true;
      };
    };
  };
}
