local gears = require("gears")
local awful = require("awful")
local global = require("global")
local widgets = require("widgets")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
local menubar = require("menubar")
local mymainmenu = require("main_menu")
local mykeyboardlayout = require("keyboard")
local utils = require("utils")

local globalkeys = gears.table.join(
	awful.key(
		{ global.modkey },
		"p",
		hotkeys_popup.show_help,
		{ description="show help", group="awesome" }
	),
	awful.key(
		{ global.modkey },
		"Left",
		awful.tag.viewprev,
		{ description = "view previous", group = "tag" }
	),
	awful.key(
		{ global.modkey },
		"Right",
		awful.tag.viewnext,
		{ description = "view next", group = "tag" }
	),
	awful.key(
		{ global.modkey },
		"Escape",
		awful.tag.history.restore,
		{ description = "go back", group = "tag" }
	),
	awful.key(
		{ "Mod1" },
		"Tab",
		function ()
			awful.client.focus.byidx(1)
		end,
		{ description = "focus next by index", group = "client" }
	),
	awful.key(
		{ "Mod1", "Shift" },
		"Tab",
		function ()
			awful.client.focus.byidx(-1)
		end,
		{ description = "focus previous by index", group = "client" }
	),
	awful.key(
		{ global.modkey },
		"w",
		function ()
			mymainmenu:show()
		end,
		{ description = "show main menu", group = "awesome" }
	),

	-- Layout manipulation
	awful.key(
		{ global.modkey, "Shift" },
		"j",
		function ()
			awful.client.swap.byidx(1)
		end,
		{ description = "swap with next client by index", group = "client" }
	),
	awful.key(
		{ global.modkey, "Shift" },
		"k",
		function ()
			awful.client.swap.byidx(-1)
		end,
		{ description = "swap with previous client by index", group = "client" }
	),
	awful.key(
		{ global.modkey, "Control" },
		"j",
		function ()
			awful.screen.focus_relative(1)
		end,
		{ description = "focus the next screen", group = "screen" }
	),
	awful.key(
		{ global.modkey, "Control" },
		"k",
		function ()
			awful.screen.focus_relative(-1)
		end,
		{ description = "focus the previous screen", group = "screen" }
	),
	awful.key(
		{ global.modkey },
		"u",
		awful.client.urgent.jumpto,
		{ description = "jump to urgent client", group = "client" }
	),
	awful.key(
		{ global.modkey },
		"Tab",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
		{ description = "go back", group = "client" }
	),

	-- Standard program
	awful.key(
		{ global.modkey },
		"Return",
		function ()
			awful.spawn(global.terminal)
		end,
		{ description = "open a terminal", group = "launcher" }
	),
	awful.key(
		{ global.modkey, "Control" },
		"r",
		awesome.restart,
		{ description = "reload awesome", group = "awesome" }
		),
	awful.key(
		{ global.modkey, "Shift" },
		"q",
		awesome.quit,
		{ description = "quit awesome", group = "awesome" }
	),
	awful.key(
		{ "Control", "Mod1" },
		"l",
			function ()
				awful.spawn.with_shell("light-locker-command --lock")
			end,
		{ description = "lock screen", group = "awesome" }
	),

	awful.key(
		{ global.modkey },
		"l",
		function ()
			awful.tag.incmwfact(0.05)
		end,
		{ description = "increase master width factor", group = "layout" }
	),
	awful.key(
		{ global.modkey },
		"h",
		function ()
			awful.tag.incmwfact(-0.05)
		end,
		{ description = "decrease master width factor", group = "layout" }
	),
	awful.key(
		{ global.modkey, "Shift" },
		"h",
		function ()
			awful.tag.incnmaster(1, nil, true)
		end,
		{ description = "increase the number of master clients", group = "layout" }
	),
	awful.key(
		{ global.modkey, "Shift" },
		"l",
		function ()
			awful.tag.incnmaster(-1, nil, true)
		end,
		{ description = "decrease the number of master clients", group = "layout" }
	),
	awful.key(
		{ global.modkey, "Control" },
		"h",
		function ()
			awful.tag.incncol(1, nil, true)
		end,
		{ description = "increase the number of columns", group = "layout" }
	),
	awful.key(
		{ global.modkey, "Control" },
		"l",
		function ()
			awful.tag.incncol(-1, nil, true)
		end,
		{ description = "decrease the number of columns", group = "layout" }
	),
	awful.key(
		{ global.modkey, "Control" },
		"space",
		function ()
			awful.layout.inc(1)
		end,
		{ description = "select next", group = "layout" }),
	awful.key(
		{ global.modkey, "Control", "Shift" },
		"space",
		function ()
			awful.layout.inc(-1)
		end,
		{ description = "select previous", group = "layout" }
	),

	awful.key(
		{ "Control", "Shift" },
		"Escape",
		function ()
			awful.spawn("xfce4-taskmanager --display=" .. os.getenv("DISPLAY"))
		end,
		{ description = "open taskmanager", group = "launcher" }
	),

	awful.key(
		{ global.modkey, "Control" },
		"n",
		function ()
				local c = awful.client.restore()
				-- Focus restored client
				if c then
					c:emit_signal(
							"request::activate", "key.unminimize", { raise = true }
					)
				end
		end,
		{ description = "restore minimized", group = "client" }
	),

	-- Prompt
	awful.key(
		{ global.modkey },
		"r",
		function ()
			awful.screen.focused().mypromptbox:run()
		end,
		{ description = "run prompt", group = "launcher" }
	),

	awful.key(
		{ global.modkey },
		"x",
		function ()
			awful.prompt.run {
				prompt       = "Run Lua code: ",
				textbox      = awful.screen.focused().mypromptbox.widget,
				exe_callback = awful.util.eval,
				history_path = awful.util.get_cache_dir() .. "/history_eval"
			}
		end,
		{ description = "lua execute prompt", group = "awesome" }
	),

	-- Menubar
	awful.key(
		{ global.modkey },
		"s",
		function()
			local screen = awful.screen.focused()
			menubar.show(screen)
		end,
		{ description = "show the menubar", group = "launcher" }
	),

	awful.key(
		{},
		"XF86AudioRaiseVolume",
		function()
			widgets.volume.control:inc(5)
		end,
		{ description = "increase volume", group = "volume" }
	),
	awful.key(
		{},
		"XF86AudioLowerVolume",
		function()
			widgets.volume.control:dec(5)
		end,
		{ description = "decrease volume", group = "volume" }
	),
	awful.key(
		{},
		"XF86AudioMute",
		function()
			widgets.volume.control:toggle()
		end,
		{ description = "toggle volume", group = "volume" }
	),
	awful.key(
		{ global.modkey },
		"space",
		function()
			mykeyboardlayout:next_layout()
		end,
		{ description = "toggle volume", group = "utils" }
	),
	awful.key(
		{},
		"Print",
		function()
			awful.spawn.with_shell("xfce4-screenshooter")
		end,
		{ description = "take a screenshot", group = "launcher" }
	)
	-- awful.key({}, "XF86MonBrightnessUp", function() widgets.brightness.control:inc() end,
	--           {description = "increase brightness", group = "custom"}),
	-- awful.key({}, "XF86MonBrightnessDown", function() widgets.brightness.control:dec() end,
	--           {description = "decrease brightness", group = "custom"})
)

for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key(
			{ global.modkey },
			"#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end,
			{ description = "view tag #"..i, group = "tag" }
		),
		-- Toggle tag display.
		awful.key(
			{ global.modkey, "Control" },
			"#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
			{ description = "toggle tag #" .. i, group = "tag" }
		),
		-- Move client to tag.
		awful.key(
			{ global.modkey, "Shift" },
			"#" .. i + 9,
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
			 end
			end,
			{ description = "move focused client to tag #"..i, group = "tag" }
		),
		-- Toggle tag on focused client.
		awful.key(
			{ global.modkey, "Control", "Shift" },
			"#" .. i + 9,
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
			{ description = "toggle focused client on tag #" .. i, group = "tag" }
		)
	)
end

return globalkeys
