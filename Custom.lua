---@meta

--This file has meta definitions for the functions implemented in mupen64.
--https://github.com/mkdasher/mupen64-rr-lua-/blob/master/lua/LuaConsole.cpp

emu = {}
memory = {}
gui = {}
wgui = {}
input = {}
joypad = {}
savestate = {}
iohelper = {}


-- Global Functions

---Prints a value to the lua console
---@param data any
function print(data)
end

---Stops script execution
function stop()
end

-- emu Functions


---Similar to print, but only accepts strings
---@param str string
function emu.console(str)
end

---Sets the statusbar text to str
---@param str string
function emu.statusbar(str)
end

---Registers a function to be run every VI
---@param func function
---@param unregister boolean?
function emu.atvi(func, unregister)
end

---Registers a function to be run when the screen updates
---@param func function
---@param unregister boolean?
function emu.atupdatescreen(func, unregister)
end

---Registers a function to be run every input frame
---@param func function
---@param unregister boolean?
function emu.atinput(func, unregister)
end

---Registers a function to be run when the lua script is stopped
---@param func function
---@param unregister boolean?
function emu.atstop(func, unregister)
end

---Registers a function to be run constantly
---@param func function
---@param unregister boolean?
function emu.atinterval(func, unregister)
end

---Registers a function to be run when a savestate is loaded
---@param func function
---@param unregister boolean?
function emu.atloadstate(func, unregister)
end

---Registers a function to be run when a savestate is saved
---@param func function
---@param unregister boolean?
function emu.atsavestate(func, unregister)
end

---Registers a function to be run when the emulator is reset
---@param func function
---@param unregister boolean?
function emu.atreset(func, unregister)
end

---Returns the number of VIs since the last movie was played. If no movie has been played, it returns the number of VIs since the emulator was started, not reset
---@return integer framecount
function emu.framecount()
end

---Returns the current input frame of the currently playing movie. If no movie is playing, it will return the last value when a movie was playing. If no movie has been played yet, it will return -1
---@return integer samplecount
function emu.samplecount()
end

---Returns the number of input frames that have happened since the emulator was started. It does not reset when a movie is started
---@return integer inputcount
function emu.inputcount()
end

---Returns the current mupen version
---@param type 1|0
---@return string version
function emu.getversion(type)
end

---Pauses or unpauses the emulator
---@param pause boolean true pauses the emulator and false resumes the emulator
function emu.pause(pause)
end

---Returns 1 if the emulator is paused and 0 if it is not
---@return boolean emu_paused
function emu.getpause()
end

---Returns the current speed limit of the emulator
---@return integer speed_limit
function emu.getspeed()
end

---Sets the speed limit of the emulator
---@param speed_limit integer
function emu.speed(speed_limit)
end

---Sets the speed mode of the emulator
---@param mode "normal"|"maximum"
function emu.speedmode(mode)
end

---?
---@param address string
function emu.getaddress(address)
end

---Returns true if the currently playing movie is read only
---@return boolean read_only
function emu.isreadonly()
end

---Gets a system metric using the windows [GetSystemMetrics](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getsystemmetrics) function
---@param param number Should really be integer, but it is cast to one anyway
---@return integer metric
function emu.getsystemmetrics(param)
end

-- memory functions


---Loads an unsigned byte from rdram and returns it. Alias for `memory.readbyte`
---@param address integer The address to read from
---@return integer value The unsigned byte at `address`
function memory.LBU(address)
end

---Loads a signed byte from rdram and returns it. Alias for `memory.readbytesigned`
---@param address integer The address to read from
---@return integer value The signed byte at `address`
function memory.LB(address)
end

---Loads an unsigned short (2 bytes) from rdram and returns it. Alias for `memory.readword`
---@param address integer The address to read from
---@return integer value The unsigned short at `address`
function memory.LHU(address)
end

---Loads a signed short (2 bytes) from rdram and returns it. Alias for `memory.readwordsigned`
---@param address integer The address to read from
---@return integer value The signed short at `address`
function memory.LH(address)
end

---Loads an unsigned long (4 bytes) from rdram and returns it. Alias for `memory.readdword`
---@param address integer The address to read from
---@return integer value The unsigned long at `address`
function memory.LWU(address)
end

---Loads a signed long (4 bytes) from rdram and returns it. Alias for `memory.readdwordsigned`
---@param address integer The address to read from
---@return integer value The signed long at `address`
function memory.LW(address)
end

---Loads a unsigned long long (8 bytes) from rdram and returns it in a table of 2 integers. Alias for `memory.readqword`
---@param address integer The address to read from
---@return table value A table containing the the upper and lower 4 bytes of the unsigned long long at `address`
function memory.LDU(address)
end

---Loads a signed long long (8 bytes) from rdram and returns it in a table of 2 integers. Alias for `memory.readqwordsigned`
---@param address integer The address to read from
---@return table value A table containing the the upper and lower 4 bytes of the signed long at `address`
function memory.LD(address)
end

---Loads a float (4 bytes) from rdram and returns it. Alias for `memory.readfloat`
---@param address integer The address to read from
---@return number value The float at `address`
function memory.LWC1(address)
end

---Loads a double (8 bytes) from rdram and returns it. Alias for `memory.readdouble`
---@param address integer The address to read from
---@return number value The double at `address`
function memory.LDC1(address)
end

---Loads `size` bytes at `address` from rdram and returns it. Alias for `memory.readsize`
---@param address integer The address to read from
---@param size integer The size to read. Must be `1`, `2`, `4`, or `8`
---@return number value `size` bytes at `address`
function memory.loadsize(address, size)
end

---Gets the current width and height of the window
---@return {width: integer, height: integer}
function wgui.info()
end
