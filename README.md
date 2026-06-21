# Syrup

VScript-based plugins for 64-bit TF2 servers.

Features:
    - Permissions (admins and non-admins), configurable in `scriptdata/admins.txt`.
    - Modular "plugin" loading. Executes all plugin `.nut` files listed in `scriptdata/plugins.txt`.
    - A collection of helper functions (located in `scripts/syrup.nut`).
    - Commands registered through `RegisterCommand` and `RegisterAdminCommand` are both accessible in chat (`?example`) and in console (`sy_example`).

## Included Plugins

- Kickban - Kick or ban a player. Effectively aliases for `kickid`/`banid`.
- Slay: Admins can target a specific player to die.
- Map: Admins can change maps.
- Rcon: Admins can execute server commands.
- Conditions: Admins give/remove conditions to themselves or others. A condition list can be accessed with `condlist`.
- Skybox: Allows you to modify the skybox along with automatic fog color changes. Fog values are persistent across connect/disconnect. Use `skylist` to view all available skyboxes.
- Noclip: Toggle noclip movement on a specific player.
- Chat: Adds `csay` command.
- Example: Example bare minimum plugin.

## Roadmap
- Sourcemod-style menus.
- Item/attribute editing plugin.
