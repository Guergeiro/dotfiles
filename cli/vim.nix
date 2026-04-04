{
  lib,
  pkgs,
  config,
  dotfilesDir,
  ...
}:
let
  vimDir = "${dotfilesDir}/cli/vim";
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
    initLua = ''
      vim.opt.runtimepath:prepend(vim.fn.expand("~/.vim"))
      vim.opt.runtimepath:append(vim.fn.expand("~/.vim/after"))
      vim.opt.packpath = vim.opt.runtimepath:get()
      vim.cmd.source(vim.fn.expand("$HOME/.vimrc"))
    '';
  };
  home.packages = with pkgs; [
    tree-sitter
    nixfmt
  ];

  home.file.".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${vimDir}/.vimrc";
  home.file.".vimrc".force = true;
  home.file.".vim/" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vimDir}/.vim/";
    recursive = true;
    force = true;
  };
}
