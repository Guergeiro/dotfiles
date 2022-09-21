source <sfile>:h/prettier-config.vim
let &l:formatprg='deno fmt -'
nnoremap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<cr>
