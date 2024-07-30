local awful = require("awful")
local wibox = require("wibox")

local separator = wibox.widget.textbox("  ")
local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local volume_widget = require("awesome-wm-widgets.pactl-widget.volume")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")

local mytextclock = wibox.widget.textclock()
local cw = calendar_widget({
	placement = "top_right",
	radius = 0,
	previous_month_button = 1,
	next_month_button = 3,
})
mytextclock:connect_signal(
	"button::press",
	function(_, _, _, button)
		if button == 1 then cw.toggle() end
	end
)

local battery = {
	icon = batteryarc_widget({
		show_current_level = true,
	}),
	control = batteryarc_widget
}
battery.icon:connect_signal(
	"button::press",
	function()
		awful.spawn("xfce4-power-manager-settings --display=" .. os.getenv("DISPLAY"))
	end
)

local brightness = {
	icon = brightness_widget({
		program = 'brightnessctl',
		timeout = 1,
		tooltip = true,
		percentage = true,
	}),
	control = brightness_widget
}

local volume = {
	icon = volume_widget({
		widget_type = 'icon',
		tooltip = true,
	}),
	control = volume_widget
}

local logout = {
	icon = logout_menu_widget({
		onlock = function()
			awful.spawn.with_shell("light-locker-command --lock")
		end
	}),
	control = logout_menu_widget
}

local widgets = {
	battery = battery,
	brightness = brightness,
	volume = volume,
	logout = logout,
	textclock = {
		icon = mytextclock
	}
}

return widgets
