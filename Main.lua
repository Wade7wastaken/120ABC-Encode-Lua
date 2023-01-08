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

-- SETTINGS
DRAWING = true
SET_VALUES = true


-- CHANGES
SlotChanges = {}
-- Can't do anything before frame 157, each frame is a table of changes
-- each change sets the variable of the corresponding slot. Setting a slot to an empty string disables it

SlotChanges[2182] = { { 1, "hspeed", "%.3f" }, { 2, "holp", "%.0f %.0f %.0f" } }
SlotChanges[94161] = { { 1, "" }, { 2, "" } }
SlotChanges[109621] = { { 1, "hspeed" }, { 2, "slidespeed" } }
SlotChanges[111994] = { { 1, "" }, { 2, "" } }

RNGChanges = {} -- sets the rng to the value

RNGChanges[2182] = 48413
RNGChanges[103409] = 10

GlobalTimerChanges = {} -- Adds the value to the global timer

GlobalTimerChanges[2182] = 42
GlobalTimerChanges[103409] = 4

OtherChanges = {} -- Ex: {{"holpx", 100}, {"holpy", 200}, {"holpz", 300}}



Author = {}

Author[0] = "70ABC"
Author[2182] = "Pannenkoek2012"
Author[94161] = "Wade7"
Author[98797] = "70ABC"
Author[103040] = "Wade7"
Author[103409] = "Pannenkoek2012"
Author[108776] = "Wade7"
Author[109309] = "70ABC"


AuthorIndices = {}

for k, _ in pairs(Author) do -- generates a linear table with only the indices from the author table
	table.insert(AuthorIndices, k)
end

table.sort(AuthorIndices)

SlotIndices = {}

for k, _ in pairs(SlotChanges) do -- same thing as the previous loop
	table.insert(SlotIndices, k)
end
table.sort(SlotIndices)

function FillSlots(frame, t, idxt)
	Draw.slots.data = { { name = "", value = "" }, { name = "", value = "" }, { name = "", value = "" } } -- clear the slots
	for i, v in ipairs(idxt) do
		if frame < v then return end
		local change = SlotChanges[v]
		Draw.slots.data[change[1]] = change[2]
	end
end

-- AT FUNCTIONS

---This function is run continuously. It is registered at the bottom of this page
function AtInterval()
	local current_input = input.get()
	InputDiff = input.diff(current_input, PreviousInput)
	-- toggle DRAWING if the end button is pressed
	if InputDiff["end"] then -- cant use .end because end is a keyword
		if DRAWING then
			Screen.contract()
		else
			Screen.expand()
		end
		DRAWING = not DRAWING
	end

	-- reset the a press counter if the home button is pressed
	if InputDiff.home then
		print("Resetting A press counter")
		APresses = 0
	end

	-- get the previous input for the next frame
	PreviousInput = current_input
end

---This function is run for every VI. It is registered at the bottom of the frame
function AtVI()
	VI = emu.framecount() + 1 -- ¯\_(ツ)_/¯

	if DRAWING then
		Draw.main() -- main draw loop. Very important to keep in vi, not interval, so it syncs when dumping avi
		--Map.draw() -- a special version of mupen is required for this function https://github.com/Wade7wastaken/mupen64-rr-lua-/tree/dev
	end
end

---This function is run for every input frame. It is registered at the bottom of this page
function AtInput()
	Frame = emu.samplecount() + 1 -- ¯\_(ツ)_/¯
	Joypad = joypad.get(1) -- get the joypad input from the first controller
	JoypadDiff = input.diff(Joypad, PreviousJoypad)
	if Memory.read('action') == 6409 then -- end cutscene action
		Draw.timer.active = false -- stop the timer when the grand star is collected
	end
	if JoypadDiff.A then -- a press counter logic
		APresses = APresses + 1
	end

	if SET_VALUES then
		local inc_segments = false -- used so the segment counter won't be incremented more than once per frame
		local rng_data = RNGChanges[Frame]
		if rng_data ~= nil then
			Memory.write("rng", rng_data)
			print("Setting RNG to " .. rng_data)
			inc_segments = true
		end

		local global_timer_data = GlobalTimerChanges[Frame]
		if global_timer_data ~= nil then
			Memory.write("globaltimer", Memory.read("globaltimer") + global_timer_data)
			print("Changing global timer by " .. global_timer_data)
			inc_segments = true
		end

		local other_data = OtherChanges[Frame]
		if other_data ~= nil then
			for _, value in ipairs(other_data) do
				Memory.write(value[1], value[2])
				print("Setting " .. value[1] .. " to " .. value[2])
			end
			inc_segments = true
		end

		if inc_segments then
			Segments = Segments + 1
		end
	end

	-- Finds the author on the current frame
	Draw.author.author = nil
	local prev = nil -- the previously checked frame
	for _, v in ipairs(AuthorIndices) do -- for every author change in the index table
		if Frame < v then -- if the frame of that author change if more than the current frame
			Draw.author.author = Author[prev] -- set the author to the previous author change
			break
		end
		prev = v
	end
	if Draw.author.author == nil then Draw.author.author = Author[AuthorIndices[#AuthorIndices]] end -- return the last author change if the loop finishes

	Draw.slots.data = { { name = "", value = "" }, { name = "", value = "" }, { name = "", value = "" } } -- clear the slots
	for _, v in ipairs(SlotIndices) do
		if Frame < v then break end
		for _, v2 in ipairs(SlotChanges[v]) do
			if v2[2] ~= "" then
				Draw.slots.data[v2[1]].name = Memory.get_display_name(v2[2])

				local mem = Memory.read(v2[2])
				local fmt = v2[3]

				local p = (type(mem) == "table") -- did Memory return a table?
				local q = (fmt ~= nil) -- is there formatting data?
				local output = ""

				if p and q then
					output = SerializeLinearTable(mem, fmt)
				elseif p and not q then
					output = SerializeLinearTable(mem)
				elseif not p and q then
					output = string.format(fmt, mem)
				elseif not p and not q then
					output = tostring(mem)
				end
				Draw.slots.data[v2[1]].value = output
			end
		end
	end

	PreviousJoypad = Joypad
end

---This function is run when the lua program is stopped. It is registered at the bottom of the page
function AtStop()
	if DRAWING then
		Screen.contract()
	end
end

PATH = debug.getinfo(1).source:sub(2):match("(.*\\)") -- From InputDirection
dofile(PATH .. "Misc.lua")
dofile(PATH .. "Screen.lua")
Screen.init() -- must be run before Draw
dofile(PATH .. "Memory.lua")
dofile(PATH .. "Draw.lua")
dofile(PATH .. "Map.lua")
dofile(PATH .. "Image.lua")

Memory.init()

Map.map1.state = 2
Map.map1.h = 300
Map.map1.x = 100
Map.map1.y = 100
Map.map1.data = { zoom = 1, x = 750, y = 750, name = "Castle Grounds", mario = true }

VI = 0
Frame = 0
APresses = 0
Segments = 1
PreviousInput = input.get() -- initialized here so there's no nil error later
InputDiff = {} -- the difference in inputs between the previous and current frames
Joypad = joypad.get(1)
PreviousJoypad = { A = false }
JoypadDiff = {}

if DRAWING then
	Screen.expand()
end

emu.atinterval(AtInterval) -- ran continuously
emu.atvi(AtVI) -- ran every visual interrupt (DRAWING happens here)
emu.atinput(AtInput) -- ran every input frame
emu.atstop(AtStop) -- ran when the script is stopped
