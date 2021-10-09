setlocal formatprg=npx\ prettier\ --stdin-filepath\ %
if has('eval')
  setlocal formatexpr=
endif
