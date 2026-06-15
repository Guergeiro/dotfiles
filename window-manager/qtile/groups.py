from libqtile.config import Group
from constants import MAIN_KEYS, SECONDARY_KEYS

def create_groups() -> list[Group]:
    return [
        Group(name=k, label=k.upper())
        for k in MAIN_KEYS
    ] + [
        Group(name=k, label=k.upper())
        for k in SECONDARY_KEYS
    ]
