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
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withNodeJs = true;
    withPerl = true;
    withRuby = true;
  };
  home.packages = with pkgs; [
    tree-sitter
    nixfmt
  ];

  home.file.".config/nvim/" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vimDir}/.config/nvim/";
    recursive = true;
    force = true;
  };
  home.file.".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${vimDir}/.vimrc";
  home.file.".vimrc".force = true;
  home.file.".vim/" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vimDir}/.vim/";
    recursive = true;
    force = true;
  };
}
