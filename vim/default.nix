{ pkgs, ... }:
{
  home.activation.stowVim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  ${pkgs.stow}/bin/stow --target ${config.home.homeDirectory} --stow ${config.home.homeDirectory}/Documents/guergeiro/dotfiles/vim
'';
}
