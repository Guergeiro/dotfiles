{
  lib,
  pkgs,
  config,
  ...
}:
{
  home.activation.stow-awesome = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.stow}/bin/stow --target ${config.home.homeDirectory} --stow awesome --dir ${config.home.homeDirectory}/Documents/guergeiro/dotfiles/awesome
  '';
}
