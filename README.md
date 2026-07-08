# Syrup

VScript-based plugins for 64-bit TF2 servers. This probably breaks with SourceMod/MetaMod, and was only tested on an otherwise vanilla server.

Features:
    - Permissions (admins and non-admins), configurable in `scriptdata/admins.txt`.
    - Modular "plugin" loading. Executes all plugin `.nut` files listed in `scriptdata/plugins.txt`.
    - A collection of helper functions (located in `scripts/syrup.nut`).
    - Commands registered through `RegisterCommand` and `RegisterAdminCommand` are both accessible in chat (`?example`) and in console (`sy_example`).
    - All commands are logged.
    - VScript API extensions:
        - Console commands (details above)
        - Menus
            - Currently limited to 4 second display time (Source Engine bug) until a workaround is added.
        - Timers (WIP, disabled)
        - Usermessage support

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

## Extended VScript API

### Console Commands

Commands registered through the Syrup VScript plugin system are automatically registered as console commands. All commands follow the same calling convention: `function Command(caller, args)`, where caller is the userID of the client calling the command, and args is an array of strings containing all arguments.

### Timers

Timers are partially implemented but disabled.

### Usermessages

Syrup adds usermessage sending support to VScript.

Example:

```c
    local msgTest = VScriptUserMessage()
    msgTest.AddByte(0)
    msgTest.AddFloat(50.0, 32)
    msgTest.AddFloat(150.0, 32)
    msgTest.AddFloat(10.0, 32)
    LogPublic("Shaking screen via usermessage!")
    msgTest.Dispatch(caller, 10)
```

Supported types to write into a buffer are `Word`, `Short`, `String`, `Char`, `Byte`, `Float`, `Coord`, `Angle`, `Vec3Coord`, `Vec3Normal`, and `Angles`. Simply create a `VScriptUserMessage` object, add the parameters, and `Dispatch` with the userID to send to along with the usermessage ID. 

### Menus

Support for Source menus is included.

Example:

```c
    ::TestMyMenu <- function(caller) { // Menu functions MUST be explicitly global.
	    LogPublic("Test menu!")
    }

    ::TestMyMenu2 <- function(caller, arg0) { // Caller is always the first arg, even for "0 arg provided" keys.
	    LogPublic(format("Test menu but with an arg! %d", arg0))
    }

    local test = VScriptMenu()
    test.SetTime(4) // This is broken... It seems like TF2 just kills the menu after 4 seconds always. Did it change?
    test.SetKeyFunc0("Test Menu", "NO_KEY") // Titles dont actually exist in the message protocol, they are just disabled keys.
    test.SetKeyFunc0("Colored menu text!", "TestMyMenu") // Functions MUST be passed as a string of the name. The VScript interface in C++ REALLY does not like passing function handles.
    test.SetKeyFunc0("This is a NO_KEY_DISABLED white line!", "NO_KEY_DISABLED") // Setting the function to "NO_KEY" will tell the dispatcher on the C++ side that this is actually a disabled key.
    test.SetKeyFunc1("Arg Test", "TestMyMenu2", 69420) // You can pass any other primitive safely though.
    test.SetKeyFunc0("This is just a line of text!", "NO_KEY") // Same as the "title" key
    test.SetKeyFunc1("Arg Test Again!", "TestMyMenu2", 6769) // You can pass any other primitive safely though.
    test.SetKeyFunc0("Exit", "EXIT") // Creates a white "Exit" key.
    test.Dispatch(caller) // Dispatches and tells the VSP which client are we dispatching to.
```

Up to 12 arguments (`SetKeyFunc12`) for a called function are supported. The arguments provided can be of any primitive type. When a key is selected, the function name provided as the second argument is executed, with the first argument always being the userID of who pressed the key, even for `SetKeyFunc0`. Special function names are reserved, namely `NO_KEY` (white plaintext), `NO_KEY_DISABLED` (auto enumerated white text, a "disabled key"), and the self-explanatory `EXIT`.

Functions referenced for a key MUST be explicitly declared in the global scope, or else the VM will not be able to find it and silently fail.

Currently, custom menu times are broken. They are hardcoded to 4 seconds, but eventually a workaround will be added. SourceMod currently addresses this by redrawing the menu every 4 seconds.
