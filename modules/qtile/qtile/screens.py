from libqtile import qtile, hook
from libqtile.config import Screen, Output
from widgets import create_screen
from constants import MONITORS

def output_priority(output: Output) -> int:
    for priority, (field, value) in enumerate(MONITORS):
        if getattr(output, field, None) == value:
            return priority
    return len(MONITORS)

def create_screens(outputs: list[Output]) -> list[Screen]:
    if not outputs:
        return []

    screens = []

    # Identify the highest priority output to mark as main
    highest_priority_output = min(outputs, key=output_priority)

    for output in outputs:
        is_main = output == highest_priority_output
        screen = create_screen(is_main=is_main)
        screen.is_main = is_main
        screens.append(screen)
    return screens


@hook.subscribe.client_mouse_enter
def client_mouse_enter(client):
    if client.screen is not qtile.current_screen:
        qtile.focus_screen(client.screen.index)
        client.focus(warp=False)
