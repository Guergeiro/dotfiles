local gears = require("gears")
local awful = require("awful")
local global = require("global")
local utils = require("utils")

local clientkeys = gears.table.join(
	awful.key(
		{},
		"F11",
		function (c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{ description = "toggle fullscreen", group = "client" }
	),
	awful.key(
		{ "Mod1" },
		"F4",
		function (c)
			c:kill()
		end,
		{ description = "close", group = "client" }
	),
	awful.key(
		{ global.modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),
	awful.key(
		{ global.modkey, "Control" },
		"Return",
		function (c)
			c:swap(awful.client.getmaster())
		end,
		{ description = "move to master", group = "client" }
	),
	awful.key(
		{ global.modkey },
		"o",
		function (c)
			c:move_to_screen()
		end,
		{ description = "move to screen", group = "client" }
	),
	awful.key(
		{ global.modkey },
		"t",
		function (c)
			c.ontop = not c.ontop
		end,
		{ description = "toggle keep on top", group = "client" }
	),
	awful.key(
		{ global.modkey },
		"n",
		function (c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end ,
		{ description = "minimize", group = "client" }
	),
	awful.key(
		{ global.modkey },
		"m",
		function (c)
			c.maximized = not c.maximized
			utils.toggle_titlebar(c)
			c:raise()
		end ,
		{ description = "(un)maximize client", group = "client" }
	),
	awful.key(
		{ global.modkey },
		"f",
		function (c)
			c.floating = not c.floating
		end ,
		{ description = "(un)float client", group = "client" }
	),
	awful.key(
		{ global.modkey, "Control" },
		"m",
		function (c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end ,
		{ description = "(un)maximize vertically", group = "client" }
	),
	awful.key(
		{ global.modkey, "Shift" },
		"m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end ,
		{ description = "(un)maximize horizontally", group = "client" }
	)
)

return clientkeys
