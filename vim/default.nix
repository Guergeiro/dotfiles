{
  lib,
  pkgs,
  config,
  dotfilesDir,
  ...
}:
let
  vimDir = "${dotfilesDir}/vim/vim";
in
{
  home.file.".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${vimDir}/.vimrc";
  home.file.".vimrc".force = true;

  home.file.".config/nvim/" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vimDir}/.config/nvim/";
    recursive = true;
    force = true;
  };
  home.file.".vim/" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vimDir}/.vim/";
    recursive = true;
    force = true;
  };
}
