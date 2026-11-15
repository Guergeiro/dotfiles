from libqtile.config import Key, Group, Click, Drag
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from constants import MOD, ALT, LSHIFT, ROFI, SCREENSHOOTER, MONITORTOOL, MAIN_KEYS

terminal = guess_terminal()

def _screen_index_for_group(qtile, name: str) -> int:
    if len(qtile.screens) == 1:
        return 0

    # Group names tell us which set they belong to; `is_main` tells us which
    # live screen currently plays that role.
    if name in MAIN_KEYS:
        for screen in qtile.screens:
            if getattr(screen, "is_main", False):
                return screen.index
    else:
        for screen in qtile.screens:
            if not getattr(screen, "is_main", False):
                return screen.index

    return 0

@lazy.function
def go_to_group(qtile, name: str):
    qtile.focus_screen(_screen_index_for_group(qtile, name))
    qtile.groups_map[name].toscreen()

@lazy.function
def go_to_group_and_move_window(qtile, name: str):
    if qtile.current_window is not None:
        qtile.current_window.togroup(name, switch_group=False)

def create_keymaps(groups: list[Group] = []) -> list[Key]:

    o = [
        Key([ALT], "Tab", lazy.group.next_window(), desc="Move window focus to other window"),
        Key([ALT, LSHIFT], "Tab", lazy.group.prev_window(), desc="Move window focus to other window"),

        Key([MOD, LSHIFT], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
        Key([MOD, LSHIFT], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
        Key([MOD, LSHIFT], "j", lazy.layout.shuffle_down(), desc="Move window down"),
        Key([MOD, LSHIFT], "k", lazy.layout.shuffle_up(), desc="Move window up"),

        Key([MOD], "Return", lazy.spawn(terminal), desc="Launch terminal"),
        Key([ALT], "F4", lazy.window.kill(), desc="Kill focused window"),
        Key([], "F11", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
        Key([MOD], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
        Key([ALT, LSHIFT], "r", lazy.reload_config(), desc="Reload the config"),
        Key([MOD, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
        Key([MOD], "s", lazy.spawn(ROFI), desc="Spawn Rofi"),
        Key([MOD], "space", lazy.widget["keyboardlayout"].next_keyboard(), desc="Next keyboard"),

        Key([], "XF86AudioRaiseVolume", lazy.widget["pulsevolume"].increase_vol()),
        Key([], "XF86AudioLowerVolume", lazy.widget["pulsevolume"].decrease_vol()),
        Key([], "XF86AudioMute", lazy.widget["pulsevolume"].mute()),
        Key([], "XF86MonBrightnessUp", lazy.widget["brightness"].brightness_up()),
        Key([], "XF86MonBrightnessDown", lazy.widget["brightness"].brightness_down()),
        Key([], "Print", lazy.spawn(SCREENSHOOTER)),
        Key([MOD], "p", lazy.spawn(MONITORTOOL)),
    ]

    # Add key bindings to switch VTs in Wayland.
    for vt in range(1, 8):
        o.append(
            Key(
                ["control", "mod1"],
                f"f{vt}",
                lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
                desc=f"Switch to VT{vt}",
            )
        )

    # Map keys to groups
    for g in groups:
        o.extend([
            Key([MOD], g.name, go_to_group(g.name), desc=f"Switch to group {g.name}"),
            Key([MOD, LSHIFT], g.name, go_to_group_and_move_window(g.name), desc=f"Move window to group {g.name}"),
        ])

    return o

def create_mousemaps():
    return [
        Drag([MOD], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
        Drag([MOD], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
        Click([MOD], "Button2", lazy.window.bring_to_front()),
    ]
