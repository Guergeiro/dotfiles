{ lib, pkgs, config, ... }:
{
  home.activation.stow-vim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.stow}/bin/stow --target ${config.home.homeDirectory} --stow vim --dir ${config.home.homeDirectory}/Documents/guergeiro/dotfiles/vim
  '';
}
