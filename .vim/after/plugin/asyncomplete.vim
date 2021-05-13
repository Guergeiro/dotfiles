augroup Setup
      autocmd!
      autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#emmet#get_source_options({
                        \ 'name': 'emmet',
                        \ 'allowlist': ['html'],
                        \ 'priority': 400,
                        \ 'completor': function('asyncomplete#sources#emmet#completor'),
                        \ }))
      autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
                        \ 'name': 'file',
                        \ 'allowlist': ['*'],
                        \ 'priority': 300,
                        \ 'completor': function('asyncomplete#sources#file#completor')
                        \ }))
      autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
                        \ 'name': 'neosnippet',
                        \ 'allowlist': ['*'],
                        \ 'priority': 500,
                        \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
                        \ }))
augroup END
