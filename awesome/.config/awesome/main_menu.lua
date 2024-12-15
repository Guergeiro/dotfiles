local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")
local global = require("global")

-- Create a launcher widget and a main menu
local myawesomemenu = {
	{
		"hotkeys",
		function() hotkeys_popup.show_help(nil, awful.screen.focused()) end
	},
	{
		"open terminal", global.terminal
	},
	{
		"manual",
		global.terminal_cmd .. "man awesome"
	},
	{
		"edit config",
		global.editor_cmd .. " " .. awesome.conffile
	},
	{
		"restart", awesome.restart
	}
}
local menu_awesome = { "Awesome", myawesomemenu }

local ICON_DIR = os.getenv("HOME") .. '/.config/awesome/awesome-wm-widgets/logout-menu-widget/icons/'
local logout_menu = {
	{
		"Log out",
		function() awesome.quit() end,
		ICON_DIR .. "log-out.svg"
	},
	{
		"Lock",
		function() awful.spawn.with_shell("light-locker-command --lock") end,
		ICON_DIR .. "lock.svg"
	},
	{
		"Reboot",
		function() awful.spawn.with_shell("reboot") end,
		ICON_DIR .. "refresh-cw.svg"
	},
	{
		"Suspend",
		function() awful.spawn.with_shell("systemctl suspend") end,
		ICON_DIR .. "moon.svg"
	},
	{
		"Power off",
		function() awful.spawn.with_shell("shutdown now") end,
		ICON_DIR .. "power.svg"
	},
}
local menu_logout = { "System", logout_menu, ICON_DIR .. "power_w.svg" }

local mymainmenu = awful.menu({
		items = {
			menu_logout,
				{ "Debian", debian.menu.Debian_menu.Debian },
			menu_awesome
		}
	})

if has_fdo then
	mymainmenu = freedesktop.menu.build({
		after = { menu_awesome },
		before =  { menu_logout }
	})
end

return mymainmenu
