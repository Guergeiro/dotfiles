local awful = require("awful")
local layouts = require("layouts")

local tags = {}
awful.screen.connect_for_each_screen(function(s)
	-- Each screen has its own tag table.
	tags[s] = awful.tag(
		-- create 0 tag so that "hidden" tags can have a place
		{"1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
		s,
		layouts[1]
	)
end)

return tags
