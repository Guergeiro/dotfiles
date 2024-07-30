local layouts = require("layouts")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local widgets = require("widgets")
local beautiful = require("beautiful")
local mymainmenu = require("main_menu")
local global = require("global")
local mykeyboardlayout = require("keyboard")
local utils = require("utils")

local separator = wibox.widget.textbox("  ")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t) t:view_only() end),
	awful.button(
		{ global.modkey },
		1,
		function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end
	),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button(
		{ global.modkey },
		3,
		function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end
	),
	awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
	awful.button(
		{},
		1,
		function (c)
			if utils.double_click() then
				c.maximized = not c.maximized
			else
				c:emit_signal(
					"request::activate",
					"tasklist",
					{ raise = true }
				)
			end
		end
	),
	awful.button(
		{},
		2,
		function (c)
			if utils.double_click() then
				c:kill()
			end
		end
	),
	awful.button(
		{},
		3,
		function()
			awful.menu.client_list({ theme = { width = 250 } })
		end
	),
	awful.button(
		{},
		4,
		function ()
			awful.client.focus.byidx(1)
		end
	),
	awful.button(
		{},
		5,
		function ()
			awful.client.focus.byidx(-1)
		end
	)
)

local mylauncher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = mymainmenu
})

function left_bar(s)
	return {
		layout = wibox.layout.fixed.horizontal,
		widgets.logout.icon,
		s.mytaglist,
		s.mypromptbox
	}
end

function right_bar(s)
	return {
		layout = wibox.layout.fixed.horizontal,
		mykeyboardlayout,
		separator,
		wibox.widget.systray(),
		separator,
		widgets.battery.icon,
		separator,
		widgets.brightness.icon,
		separator,
		widgets.volume.icon,
		separator,
		widgets.textclock.icon,
		separator,
		s.mylayoutbox
	}
end

local topbars = {}

awful.screen.connect_for_each_screen(function(s)
	-- Create the wibox
	topbars[s] = awful.wibar({ position = "top", screen = s })

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(
		gears.table.join(
			awful.button({}, 1, function () awful.layout.inc(1) end),
			awful.button({}, 3, function () awful.layout.inc(-1) end),
			awful.button({}, 4, function () awful.layout.inc(1) end),
			awful.button({}, 5, function () awful.layout.inc(-1) end)
		)
	)
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist {
		screen = s,
		filter = function (t)
			-- ignore "0" tag
			return t.name ~= "0"
		end,
		buttons = taglist_buttons
	}

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist {
		screen = s,
		filter = function (c, s)
			if awful.widget.tasklist.filter.currenttags(c, s) then
				-- only show maximed in tasklist
				return c.maximized
			end
			return false
		end,
		buttons = tasklist_buttons
	}

	-- Add widgets to the wibox
	topbars[s]:setup {
		layout = wibox.layout.align.horizontal,
		left_bar(s),
		s.mytasklist, -- Middle widget
		right_bar(s),
	}

	s.mywibox = topbars[s]
end)

return topbars
