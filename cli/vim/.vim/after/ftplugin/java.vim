if !exists('*s:getFormatter')
	function! s:getFormatter() abort
		let l:formatprg = 'google-java-format --skip-reflowing-long-strings -'
		return l:formatprg
	endfunction
endif

let &l:formatprg=<sid>getFormatter()

if has('nvim')
lua << EOF
local full_path_to_binary = vim.fn.exepath("jdtls")

if not full_path_to_binary or full_path_to_binary == "" then
	return
end
local components = {}
for component in full_path_to_binary:gmatch("([^/]+)") do
	table.insert(components, component)
end
table.remove(components)
table.remove(components)

local parent_dir = "/" .. table.concat(components, "/") .. "/share/java/jdtls"
local config = vim.loop.os_uname().sysname == "Darwin" and "/config_mac" or "/config_linux"

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    '-jar', vim.fn.glob(parent_dir .. '/plugins/org.eclipse.equinox.launcher_*.jar'),


    '-configuration', parent_dir .. config,
    '-data', vim.fn.getcwd()
  }
}
-- require('jdtls').start_or_attach(config)
EOF
endif
