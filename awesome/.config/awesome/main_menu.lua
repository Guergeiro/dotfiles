local awful = require("awful")
local beautiful = require("beautiful")
-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")
local global = require("global")

-- Create a launcher widget and a main menu
local myawesomemenu = {
	{ "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
	{ "manual", global.terminal_cmd .. "man awesome" },
	{ "edit config", global.editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{ "quit", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", global.terminal }

local mymainmenu = {}

if has_fdo then
	mymainmenu = freedesktop.menu.build({
		before = { menu_awesome },
		after =  { menu_terminal }
	})
else
	mymainmenu = awful.menu({
		items = {
			menu_awesome,
				{ "Debian", debian.menu.Debian_menu.Debian },
			menu_terminal,
		}
	})
end

return mymainmenu
