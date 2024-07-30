local awful = require("awful")
local beautiful = require("beautiful")
local globalkeys = require("globalkeys")
local clientkeys = require("clientkeys")
local clientbuttons = require("clientbuttons")

local rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			floating = true,  -- Make all clients floating
			size_hints_honor = false,
			placement = awful.placement.no_overlap+awful.placement.no_offscreen
		}
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA",  -- Firefox addon DownThemAll.
				"copyq",  -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin",  -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer"
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester",  -- xev.
			},
			role = {
				"AlarmWindow",  -- Thunderbird's calendar.
				"ConfigManager",  -- Thunderbird's about:config.
				"pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
			}
		},
		properties = {
			floating = true
		}
	},

	-- Non Floating clients.
	-- {
	-- 	rule_any = {
	-- 		instance = {
	-- 			"Navigator"
	-- 		},
	-- 		class = {
	-- 			"Firefox",
	-- 		},
	-- 	},
	-- 	properties = {
	-- 		floating = false,
	-- 		maximized = true,
	-- 	}
	-- },

	-- Fullscreen clients.
	{
		rule_any = {
			instance = {
				"Alacritty",
			},
		},
		properties = {
			tag = "1",
			floating = false,
			fullscreen = true
		}
	},

	-- Desktop
	{
		rule_any = {
			type = {
				"desktop"
			}
		},
		callback = function(c)
			c.screen = awful.screen.getbycoord(0, 0)
		end,
		properties = {
			tag = "0",
			sticky = true,
			border_width = 0,
			skip_taskbar = true,
			titlebars_enabled = false,
			keys = {}
		}
	},

	-- Add titlebars to normal clients and dialogs
	{
		rule_any = {
			type = {
				"normal",
				"dialog"
			}
		},
		properties = {
			titlebars_enabled = true
		}
	},

	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { screen = 1, tag = "2" } },
}

return rules
