/*
 * Copyright 2023 mountainflaw
 * 
 * Redistribution and use in source and binary forms, with or without modification, are
 * permitted provided that the following conditions are met:
 * 
 * Redistributions of source code must retain the above copyright notice, this list of 
 * conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other
 * materials provided with the distribution.
 *
 * Neither the name of the copyright holder nor the names of its contributors may be
 * used to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.[8]
 */

// All plugins must have GetPluginProperty() implemented to return plugin information
// to Syrup.

local pName = "Example Plugin"
local pAuth = "mountainflaw"
local pVers = "1.0"
local pDesc = "An example plugin."

function GetPluginProperty(prop) {
    switch (prop) {
        case 0: return pName
        case 1: return pVers
        case 2: return pAuth
        case 3: return pDesc
        default: return null
    }
}

// Example menu functions

::TestMyMenu <- function(caller) { // Menu functions MUST be explicitly global.
	LogPublic("Test menu!")
}

::TestMyMenu2 <- function(caller, arg0) { // Caller is always the first arg, even for "0 arg provided" keys.
	LogPublic(format("Test menu but with an arg! %d", arg0))
}

// All command functions have the arguments caller (client ID of command caller), and
// argv, which is an array containing all of the command arguments in string format.

function CommandExample(caller, argv) {
    local test = VScriptMenu()

    LogPrivate(caller, "Drawing menu!")
    test.SetTime(4) // This is broken... It seems like TF2 just kills the menu after 3 seconds always. Did it change?
    test.SetKeyFunc0("Test Menu", "NO_KEY") // Titles dont actually exist in the message protocol, they are just disabled keys.
    test.SetKeyFunc0("Colored menu text!", "TestMyMenu") // Functions MUST be passed as a string of the name. The VScript interface in C++ REALLY does not like passing function handles.
    test.SetKeyFunc0("This is a NO_KEY_DISABLED white line!", "NO_KEY_DISABLED") // Setting the function to "NO_KEY" will tell the dispatcher on the C++ side that this is actually a disabled key.
    test.SetKeyFunc1("Arg Test", "TestMyMenu2", 69420) // You can pass any other primitive safely though.
    test.SetKeyFunc0("This is just a line of text!", "NO_KEY") // Same as the "title" key
    test.SetKeyFunc1("Arg Test Again!", "TestMyMenu2", 6769) // You can pass any other primitive safely though.
    test.SetKeyFunc0("Exit", "EXIT") // Creates a white "Exit" key.
    test.Dispatch(caller) // Dispatches and tells the VSP which client are we dispatching to.

// Example usermessage

    local msgTest = VScriptUserMessage()
    msgTest.AddByte(0)
    msgTest.AddFloat(50.0, 32)
    msgTest.AddFloat(150.0, 32)
    msgTest.AddFloat(10.0, 32)
    LogPrivate(caller, "Shaking screen via usermessage!")
    msgTest.Dispatch(caller, 10)

    LogPrivate(caller, "This is an example command.")
}

// OnPluginStart() is called by Syrup on plugin load immediately.

function OnPluginStart() {
    // Tells Syrup to register a command called "test". Can be called in chat with "?test".
    // The last argument is what appears in the help menu as a description.

    RegisterCommand("test", CommandExample, "An example command.")
}
