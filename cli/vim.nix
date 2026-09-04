{
  pkgs,
  config,
  dotfilesDir,
  minpac,
  inputs,
  ...
}:
let
  vimDir = "${dotfilesDir}/cli/vim";

  unpackedVimPlugins =
    pkgs.lib.genAttrs
      [
        "clean-path-vim"
        "vim-altscreen"
        "vim-fern"
        "vim-fern-git-status"
        "vim-fern-hijack"
        "vim-fern-renderer-nerdfont"
        "vim-nerdfont"
        "vim-smartpairs"
        "diffconflicts"
      ]
      (
        name:
        pkgs.vimUtils.buildVimPlugin {
          pname = name;
          version = inputs.${name}.shortRev;
          src = inputs.${name};
        }
      );
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
    plugins =
      (with pkgs.vimPlugins; [
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
        {
          type = "viml";
          plugin = vim-tmux-navigator;
          optional = true;
        }
        {
          type = "viml";
          plugin = dracula-vim;
          optional = true;
        }
        {
          type = "viml";
          plugin = lightline-vim;
          optional = true;
        }
        {
          type = "viml";
          plugin = vim-gitbranch;
          optional = true;
        }
        {
          type = "viml";
          plugin = gruvbox-community;
          optional = true;
        }
        {
          type = "viml";
          plugin = vim-vsnip;
          optional = true;
        }
        {
          type = "viml";
          plugin = friendly-snippets;
          optional = true;
        }
        {
          type = "viml";
          plugin = vim-highlightedyank;
          optional = true;
        }
        {
          type = "viml";
          plugin = undotree;
          optional = true;
        }
        {
          type = "viml";
          plugin = committia-vim;
        }
        {
          type = "viml";
          plugin = vim-cool;
          optional = true;
        }
        {
          type = "viml";
          plugin = vim-commentary;
        }
        {
          type = "viml";
          plugin = vim-surround;
        }
        {
          type = "viml";
          plugin = vim-polyglot;
          optional = true;
        }
        {
          type = "viml";
          plugin = ddc-vim;
        }
        {
          type = "viml";
          plugin = ddc-ui-pum;
        }
        {
          type = "viml";
          plugin = ddc-fuzzy;
        }
        {
          type = "viml";
          plugin = ddc-source-lsp;
        }
        {
          type = "viml";
          plugin = ddc-source-file;
        }
        {
          type = "viml";
          plugin = ddc-source-around;
        }
        {
          type = "viml";
          plugin = ddc-filter-sorter_rank;
        }
        {
          type = "viml";
          plugin = ddc-filter-matcher_head;
        }
        {
          type = "viml";
          plugin = ddc-filter-matcher_length;
        }
        {
          type = "viml";
          plugin = pum-vim;
        }
        {
          type = "viml";
          plugin = denops-vim;
        }
        {
          type = "viml";
          plugin = copilot-vim;
          optional = true;
        }
        {
          type = "viml";
          plugin = plenary-nvim;
          optional = true;
        }
        {
          type = "viml";
          plugin = telescope-nvim;
          optional = true;
        }
        {
          type = "viml";
          plugin = nvim-lspconfig;
        }
        {
          type = "viml";
          plugin = nvim-lspconfig;
        }
        {
          type = "viml";
          plugin = nvim-jdtls;
        }
      ])
      ++ (with unpackedVimPlugins; [
        {
          type = "viml";
          plugin = clean-path-vim;
          optional = true;
        }
        {
          type = "viml";
          plugin = vim-altscreen;
        }
        {
          type = "viml";
          plugin = vim-fern;
          optional = true;
        }
        {
          type = "viml";
          plugin = vim-fern-git-status;
          optional = true;
        }
        {
          type = "viml";
          plugin = vim-fern-hijack;
        }
        {
          type = "viml";
          plugin = vim-fern-renderer-nerdfont;
          optional = true;
        }
        {
          type = "viml";
          plugin = vim-nerdfont;
        }
        {
          type = "viml";
          plugin = vim-smartpairs;
          optional = true;
        }
        {
          type = "viml";
          plugin = diffconflicts;
        }
        {
          type = "viml";
          plugin = ddc-source-rg;
        }
        {
          type = "viml";
          plugin = ddc-filter-converter_remove_overlap;
        }
        {
          type = "viml";
          plugin = ddc-source-vsnip;
        }
        {
          type = "viml";
          plugin = ddc-buffer;
        }
        {
          type = "viml";
          plugin = scalpel;
          optional = true;
        }
      ]);
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
