import os
import libqtile.resources
from libqtile import bar
from libqtile.config import Screen
from qtile_extras import widget
from constants import MAIN_KEYS, SECONDARY_KEYS

logo = os.path.join(os.path.dirname(libqtile.resources.__file__), "logo.png")


def create_groupbox(is_main: bool) -> widget.GroupBox:
    visible = MAIN_KEYS if is_main else SECONDARY_KEYS
    return widget.GroupBox(
        visible_groups=visible,
        disable_drag=True,
        toggle=False,
        highlight_method='block',
    )

def create_screen(is_main: bool) -> Screen:
    top_widgets = [
        widget.QuickExit(),
        create_groupbox(is_main),
        widget.Spacer()
    ]

    if is_main:
        top_widgets.extend([
            widget.KeyboardLayout(configured_keyboards=["us", "us(intl)"]),
            widget.StatusNotifier(),
            widget.UPowerWidget(),
            widget.BrightnessControl(name="brightness"),
            widget.PulseVolumeExtra(name="pulsevolume"),
            widget.Clock(format="%Y-%m-%d %a %H:%M"),
        ])

    top_widgets.append(widget.CurrentLayout(mode="icon"))

    return Screen(
        top=bar.Bar(
            top_widgets,
            24,
            background="#000000",
        ),
        wallpaper=logo,
        wallpaper_mode="center",
    )
