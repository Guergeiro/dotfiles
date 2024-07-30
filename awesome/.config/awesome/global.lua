local global = {
		modkey = "Mod4",
		terminal = os.getenv("HOME") .. "/.local/share/alacritty/bin/alacritty",
		editor = os.getenv("EDITOR") or "editor"
}

global.terminal_cmd = global.terminal .. " -e "
global.editor_cmd = global.terminal .. " -e " .. global.editor
global.terminal_cmd_format = global.terminal_cmd .. "%s"

return global
