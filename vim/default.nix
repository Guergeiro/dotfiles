{
  lib,
  pkgs,
  config,
  ...
}:
let
	dotfilesDir = "${config.home.homeDirectory}/Documents/guergeiro/dotfiles/vim/vim";
in
{
  home.file.".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.vimrc";
  home.file.".vimrc".force = true;

  home.file.".config/nvim/" = {
	  source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/nvim/";
	  recursive = true;
	  force = true;
  };
  home.file.".vim/" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.vim/";
    recursive = true;
	  force = true;
  };
}
