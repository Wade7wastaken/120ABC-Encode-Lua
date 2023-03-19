---@meta

--This file has meta definitions for the functions implemented in mupen64.

emu = {}
memory = {}
gui = {}
wgui = {}
input = {}
joypad = {}
savestate = {}
iohelper = {}


--Global Function

---Prints a value to the lua console
---@param data any
function print(data)
end

---Stops script execution
function stop()
end

--Emu Functions

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
