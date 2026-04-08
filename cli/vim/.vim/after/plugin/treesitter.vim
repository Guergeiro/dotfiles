if has('nvim')
	packadd nvim-treesitter
lua << EOF
require("nvim-treesitter.install").prefer_git = true

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local filetype = args.match
		local lang = vim.treesitter.language.get_lang(filetype)
		if vim.tbl_contains(require("nvim-treesitter").get_installed(), lang) then
			require("nvim-treesitter").update(lang):await(function()
				vim.treesitter.start()
			end)
		elseif vim.tbl_contains(require("nvim-treesitter").get_available(), lang) then
			require("nvim-treesitter").install(lang):await(function()
				vim.treesitter.start()
			end)
		end
	end
})
EOF
endif
