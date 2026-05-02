{
  pkgs,
  config,
  dotfilesDir,
  minpac,
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
    plugins = with pkgs.vimPlugins; [
      {
        type = "lua";
        plugin = nvim-treesitter.withAllGrammars;
        config = ''
          vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
              local filetype = args.match
              local lang = vim.treesitter.language.get_lang(filetype)
              local success, is_installed = pcall(vim.treesitter.language.add, lang)
              if success and is_installed then
                vim.treesitter.start()
              end
            end,
          })
        '';
      }
    ];
  };
  home.packages = with pkgs; [
    tree-sitter
  ];

  home.file.".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${vimDir}/.vimrc";
  home.file.".vimrc".force = true;
  home.file.".vim/" = {
    source = config.lib.file.mkOutOfStoreSymlink "${vimDir}/.vim/";
    recursive = true;
    force = true;
  };
  home.file.".vim/pack/minpac/opt/minpac" = {
    source = config.lib.file.mkOutOfStoreSymlink minpac;
    recursive = true;
    force = true;
  };
}
