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

-- Emu Functions


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
