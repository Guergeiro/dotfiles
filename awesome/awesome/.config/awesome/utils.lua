local awful = require("awful")
local gears = require("gears")

local function toggle_titlebar(c)
	if c.maximized == true or c.requests_no_titlebar then
		awful.titlebar.hide(c)
	else
		awful.titlebar.show(c)
	end
end

local double_click_timer = nil
local function double_click()
	if double_click_timer then
		double_click_timer:stop()
		double_click_timer = nil
		return true
	end

	double_click_timer = gears.timer.start_new(0.20, function()
		double_click_timer = nil
		return false
	end)
end

local utils = {
	toggle_titlebar = toggle_titlebar,
	toggle_topbar = toggle_topbar,
	double_click = double_click
}

return utils
