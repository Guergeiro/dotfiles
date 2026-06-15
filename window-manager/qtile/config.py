# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess

import libqtile.resources
from libqtile import bar, layout, qtile, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, Output
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.backend.wayland import InputConfig
from qtile_extras import widget

@hook.subscribe.startup_once
def autostart():
    if qtile.core.name == "wayland":
        subprocess.run(
            [
                "systemctl",
                "--user",
                "import-environment",
                "WAYLAND_DISPLAY",
                "DISPLAY",
                "XDG_SESSION_TYPE",
                "XDG_SESSION_DESKTOP",
            ],
            check=False,
        )
        subprocess.run(["systemctl", "--user", "start", "kanshi.service"], check=False)

    subprocess.run(["systemctl", "--user", "restart", "blueman-applet.service"], check=False)
    subprocess.run(["systemctl", "--user", "restart", "nm-applet.service"], check=False)

mod = "mod4"
alt = "mod1"
lshift = "shift"
terminal = guess_terminal()
rofi = "rofi -show drun"
screenshooter = "xfce4-screenshooter"
monitortool = "xfce4-display-settings"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([alt], "Tab", lazy.group.next_window(), desc="Move window focus to other window"),
    Key([alt, lshift], "Tab", lazy.group.prev_window(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, lshift], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, lshift], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, lshift], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, lshift], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([alt], "F4", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [],
        "F11",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "f", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([alt, lshift], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "s", lazy.spawn(rofi), desc="Spawn rofi in drun mode"),
    Key([mod], "space", lazy.widget["keyboardlayout"].next_keyboard(), desc="Next keyboard layout"),
    Key([], "XF86AudioRaiseVolume", lazy.widget["pulsevolume"].increase_vol(), desc="Increase volume" ),
    Key([], "XF86AudioLowerVolume", lazy.widget["pulsevolume"].decrease_vol(), desc="Decrease volume" ),
    Key([], "XF86AudioMute", lazy.widget["pulsevolume"].mute(), desc="Mute volume" ),
    Key([], "XF86MonBrightnessUp", lazy.widget["brightness"].brightness_up(), desc="Increase brightness" ),
    Key([], "XF86MonBrightnessDown", lazy.widget["brightness"].brightness_down(), desc="Decrease brightness" ),
    Key([], "Print", lazy.spawn(screenshooter), desc="Spawn screenshooter"),
    Key([mod], "p", lazy.spawn(monitortool), desc="Spawn monitor tool"),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

layouts = [
    layout.Max(),
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=2, fair=True),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    layout.Matrix(border_focus=["#d75f5f", "#8f3d3d"], border_width=2),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

logo = os.path.join(os.path.dirname(libqtile.resources.__file__), "logo.png")

MAX_SIZE = 9

def get_screen_group(screen_idx: int, tag: int) -> str:
    return f"{screen_idx}:{tag}"

# Create default groups
groups = [
    Group(name=get_screen_group(screen, tag), screen_affinity=screen, label=str(tag + 1))
    for screen in range(MAX_SIZE)
    for tag in range(MAX_SIZE)
]

# Add key bindings to switch to each group and move windows to each group
# https://docs.qtile.org/en/stable/manual/faq.html#how-can-i-get-my-groups-to-stick-to-screens
@lazy.function
def go_to_group(qtile, tag: int):
    screen_group = get_screen_group(qtile.current_screen.index, tag)
    qtile.groups_map[screen_group].toscreen()

@lazy.function
def move_to_group(qtile, tag: int):
    screen_group = get_screen_group(qtile.current_screen.index, tag)
    qtile.current_window.togroup(screen_group)

for i in range(MAX_SIZE):
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                str(i + 1),
                go_to_group(i),
                desc=f"Switch to group {i} of current screen",
            ),
            # mod + shift + group number = move focused window to group
            Key(
                [mod, lshift],
                str(i + 1),
                move_to_group(i),
                desc=f"move focused window to group {i} of current screen",
            )
        ]
    )

def create_groupbox(screen_idx: int) -> widget.GroupBox:
    return widget.GroupBox(
        visible_groups=[get_screen_group(screen_idx, tag) for tag in range(MAX_SIZE)],
        disable_drag=True,
        toggle=False,
        mouse_callbacks={
            "Button1": lambda: None,
        }
    )

def create_screen(screen_idx: int, is_main: bool) -> Screen:
    top_widgets = [
        widget.QuickExit(),
        create_groupbox(screen_idx),
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
        ),
        background="#000000",
        wallpaper=logo,
        wallpaper_mode="center",
    )

@hook.subscribe.client_mouse_enter
def client_mouse_enter(client):
    if client.screen is not qtile.current_screen:
        qtile.focus_screen(client.screen.index)
        client.focus(warp=False)

SCREEN_PRIORITY = [
    ("serial", "CNK107263B"),
    ("port", "eDP-1"),
]

def output_priority(output: Output) -> int:
    for priority, (field, value) in enumerate(SCREEN_PRIORITY):
        if getattr(output, field, None) == value:
            return priority
    return len(SCREEN_PRIORITY)


def generate_screens(outputs: list[Output]) -> list[Screen]:
    highest_priority_output = min(outputs, key=output_priority)

    screens = []

    for idx, output in enumerate(outputs):
        if output == highest_priority_output:
            screens.append(create_screen(idx, is_main=True))
        else:
            screens.append(create_screen(idx, is_main=False))

    return screens

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = True
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = {
    "type:keyboard": InputConfig(
        kb_layout="us,us(intl)",
        kb_options="terminate:ctrl_alt_bksp",
    ),
    "type:touchpad": InputConfig(
        tap=True,
        natural_scroll=True,
        scroll_method="two_finger",
    ),
}

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
