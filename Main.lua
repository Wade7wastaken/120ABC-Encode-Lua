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
-- Can't do anything before 157, each frame is a table of changes
-- change format = {action, value} where action is 1 (add) or 2 (remove) and value is the input to that function
-- ex: SlotChanges[200] = {{1, "hspeed"}, {1, "action"}}

-- slots are broken rn
--SlotChanges[2182] = {{1, "hspeed"}, {1, "holp"}}
--SlotChanges[94161] = {{2, 1}, {2, 1}}
--SlotChanges[109621] = {{1, "hspeed"}, {1, "slidespeed"}}
--SlotChanges[111994] = {{2, 1}, {2, 1}}

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

---Finds the author on a given frame
---@param frame integer The frame to find the author on
---@param t table The table of Authors
---@param idxt table The index table of authors
---@return string author The author for a given frame
function FindAuthor(frame, t, idxt)
	local prev = nil -- the previously checked frame
	for _, v in ipairs(idxt) do -- for every author change in the index table
		if frame < v then -- if the frame of that author change if more than the current frame
			return t[prev] -- return the frame of the previous author change
		end
		prev = v
	end
	return t[idxt[#idxt]] -- return the last author change if the loop finishes
end

-- AT FUNCTIONS

---This function is run continuously. It is registered at the bottom of this page
function AtInterval()
	-- toggle DRAWING if the end button is pressed
	if ((not PreviousInput["end"]) and (input.get()["end"])) then
		if DRAWING then
			Screen.contract()
		else
			Screen.expand()
		end
		DRAWING = not DRAWING
	end

	-- reset the a press counter if the home button is pressed
	if ((not PreviousInput["home"]) and (input.get()["home"])) then
		print("Resetting A press counter")
		APresses = 0
	end

	-- get the previous input for the next frame
	PreviousInput = input.get()
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
	if Memory.read('action') == 6409 then -- end cutscene action
		Draw.timer.active = false -- stop the timer when the grand star is collected
	end
	if Joypad.A and not PreviousJoypad.A then -- a press counter logic
		APresses = APresses + 1
	end

	-- i need to rewrite the slot code

	Slots.clearAll()

	-- refills the slots with the correct values for the current frame
	for _, value in ipairs(SlotIndices) do -- for every slot change in SlotIndicies
		if value <= Frame then -- if the change happened before the current frame
			local slotdata = SlotChanges[value] -- gets the actual changes for that frame
			for idx2, value2 in ipairs(slotdata) do -- for every change in that change
				if value2[1] == 1 then
					Slots.add(value2[2])
				end
				if value2[1] == 2 then
					Slots.remove(value2[2])
				end
			end
		else -- if the change happens after the current frame, break cause we're done
			break
		end
	end

	if SET_VALUES then
		local inc_segments = false -- used so the segment counter won't be incremented more than once per frame
		local rngdata = RNGChanges[Frame]
		if rngdata ~= nil then
			Memory.write("rng", rngdata)
			print("Setting RNG to " .. rngdata)
			inc_segments = true
		end

		local global_timer_data = GlobalTimerChanges[Frame]
		if global_timer_data ~= nil then
			Memory.write("globaltimer", Memory.read("globaltimer") + global_timer_data)
			print("Changing global timer by " .. global_timer_data)
			inc_segments = true
		end

		local otherdata = OtherChanges[Frame]
		if otherdata ~= nil then
			for index, value in ipairs(otherdata) do
				Memory.write(value[1], value[2])
				print("Setting " .. value[1] .. " to " .. value[2])
			end
			inc_segments = true
		end

		if inc_segments then
			Segments = Segments + 1
		end
	end

	Draw.author.author = FindAuthor(Frame, Author, AuthorIndices)

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
dofile(PATH .. "Slots.lua")
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
Joypad = joypad.get(1)
PreviousJoypad = { A = false }

if DRAWING then
	Screen.expand()
end

emu.atinterval(AtInterval) -- ran continuously
emu.atvi(AtVI) -- ran every visual interrupt (DRAWING happens here)
emu.atinput(AtInput) -- ran every input frame
emu.atstop(AtStop) -- ran when the script is stopped
