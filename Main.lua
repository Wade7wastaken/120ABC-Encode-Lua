-- Look at Screen.lua before running this script

--[[
	Formatting guidelines:
	Global variables and functions use Pascal Case. Ex: ThisIsAFunction(), GlobalVariable
	Local variables and functions use Snake Case. Ex: local this_is_a_function(), local cool_variable
	Settings and other very important global variables use Screaming Snake Case. Ex: DRAWING_ENABLED, PATH
	Try to minimize the use of global variables. If a variable doesn't need to be used outside a function, mark it as local
	Every function should have annotations giving the types of its parameters and returns
	A function's description should be put above the annotations
]]
-- CUSTOM TYPES

---@alias version "JP"|"US"

-- SETTINGS

DRAWING = true
SET_VALUES = true
DEBUG = true

-- GLOBAL VARIABLES

SlotChanges = {}
RNGChanges = {}
GlobalTimerChanges = {}
OtherChanges = {}
AuthorChanges = {}
AuthorIndices = {}
SlotIndices = {}
Notes = {}
VI = 0
Frame = 0
APresses = 0
Segments = 1
PreviousInput = input.get() -- initialized here so there's no nil error later
InputDiff = {} -- the difference in inputs between the previous and current frames
Joypad = joypad.get(1)
PreviousJoypad = {A = false}

Path = debug.getinfo(1).source:sub(2):match("(.*\\)") -- From InputDirection
dofile(Path .. "Misc.lua")
dofile(Path .. "Data.lua")
dofile(Path .. "Screen.lua")
dofile(Path .. "Memory.lua")
dofile(Path .. "Draw.lua")
--dofile(Path .. "Map.lua")
dofile(Path .. "Image.lua")
dofile(Path .. "AtFunctions.lua")

print(Memory.readwafel("gMarioState.numCoins"))

emu.atinterval(AtInterval) -- ran continuously
emu.atvi(AtVI) -- ran every visual interrupt (DRAWING happens here)
emu.atinput(AtInput) -- ran every input frame
emu.atstop(AtStop) -- ran when the script is stopped
emu.atreset(AtReset) -- ran when the emulator is reset
