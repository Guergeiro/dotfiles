{ pkgs, ... }:
{
  gtk = {
    enable = true;
    iconTheme = pkgs.dracula-icon-theme;
    theme = pkgs.dracula-theme;
  };
}
