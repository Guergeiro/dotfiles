-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err)
		})
		in_error = false
	end)
end

local function run_once(cmd_arr)
	for _, cmd in ipairs(cmd_arr) do
		findme = cmd
		firstspace = cmd:find(" ")
		if firstspace then
			findme = cmd:sub(0, firstspace-1)
		end
		awful.spawn.with_shell(
			string.format(
				"pgrep -u $USER -x %s > /dev/null || (%s)",
				findme,
				cmd
			)
		)
	end
end

run_once({
	"xfsettingsd --sm-client-disable",
	"xfce4-power-manager",
	"light-locker",
	"nm-applet",
	"blueman-applet",
	"mintupdate-launcher"
})


-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local global = require("global")
local layouts = require("layouts")

awful.layout.layouts = layouts

menubar.utils.terminal = global.terminal

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

root.buttons(require("mousebuttons"))

globalkeys = require("globalkeys")
clientkeys = require("clientkeys")
clientbuttons = require("clientbuttons")

root.keys(globalkeys)

awful.rules.rules = require("rules")

require("tags")
require("client")
