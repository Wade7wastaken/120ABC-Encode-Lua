-- Look at Screen.lua before running this script

-- SETTINGS
drawing = true
set_values = true


-- CHANGES
slotc = {} -- slot changes
-- Can't do anything before 157, each frame is a table of changes.
-- change format = {action, value} where action is 1 (add) or 2 (remove) and value is the input to that function
-- ex: Slotc[200] = {{1, "hspeed"}, {1, "action"}}

-- slots are broken rn
--slotc[2182] = {{1, "hspeed"}, {1, "holp"}}
--slotc[94161] = {{2, 1}, {2, 1}}
--slotc[109621] = {{1, "hspeed"}, {1, "slidespeed"}}
--slotc[111994] = {{2, 1}, {2, 1}}

rng = {} -- rng changes

rng[2182] = 48413
rng[103409] = 10

globt = {} -- global timer changes. Adds the value to the global timer

globt[2182] = 42
globt[103409] = 4

otherc = {} -- other changes ex: {{"holpx", 100}, {"holpy", 200}, {"holpz", 300}}



author = {}

author[0] = "70ABC"
author[2182] = "Pannenkoek2012"
author[94161] = "Wade7"
author[98797] = "70ABC"
author[103040] = "Wade7"
author[103409] = "Pannenkoek2012"
author[108776] = "Wade7"
author[109309] = "70ABC"

authoridx = {}

for k, _ in pairs(author) do -- generates a linear table with only the indicies from the author table
	table.insert(authoridx, k)
end

table.sort(authoridx)

slotidx = {}

for k, _ in pairs(slotc) do -- same thing as the previous loop
	table.insert(slotidx, k)
end
table.sort(slotidx)

-- finds the author on a given frame
function findAuthor(frame, t, idxt) -- frame, table, idxtable
	local prev = nil -- the previous checked frame
	for _, v in ipairs(idxt) do -- for every author change in the index table
		if frame < v then -- if the frame of that author change if more than the current frame
			return t[prev] -- return the frame of the previous author change
		end
		prev = v
	end
	return t[idxt[#idxt]] -- return the last author change if the loop finishes
end

-- AT FUNCTIONS
function atinterval()
	-- toggle drawing if the end button is pressed
	if ((not prev_input["end"]) and (input.get()["end"])) then
		if drawing then
			Screen.contract()
		else
			Screen.expand()
		end
		drawing = not drawing
	end

	-- reset the a press counter if the home button is pressed
	if ((not prev_input["home"]) and (input.get()["home"])) then
		print("Resetting A press counter")
		a_presses = 0
	end

	-- get the previous input for the next frame
	prev_input = input.get()
end

function atvi()
	vi = emu.framecount() + 1 -- ¯\_(ツ)_/¯

	if drawing then
		Draw.main() -- main draw loop. Very important to keep in vi, not interval, so it syncs up when dumping avi
		--Map.draw() -- a special version of mupen is required for this function https://github.com/Wade7wastaken/mupen64-rr-lua-/tree/dev
	end
end

function atinput()
	frame = emu.samplecount() + 1 -- ¯\_(ツ)_/¯
	Joypad = joypad.get(1) -- get the joypad input from the first controller
	if Memory.read('action') == 6409 then -- end cutscene action
		Draw.timer.active = false -- stop the timer when the grand star is collected
	end
	if Joypad.A and not prev_Joypad.A then -- a press counter logic
		a_presses = a_presses + 1
	end

	-- i still need to rewrite the slot code

	Slots.clearAll()

	-- refills the slots with the correct values for the current frame
	for idx, value in ipairs(slotidx) do -- for every slot change in slotidx
		if value <= frame then -- if the change happened before the current frame
			local slotdata = slotc[value] -- gets the actuall changes for that frame
			for idx2, value2 in ipairs(slotdata) do -- for every change in that change
				if value2[1] == 1 then
					Slots.add(value2[2])
				end
				if value2[1] == 2 then
					Slots.remove(value2[2])
				end
			end
		else -- if the change happenes after the current frame, break cause we're done
			break
		end
	end

	if set_values then
		local inc_segments = false -- used so the segment counter won't be incremented more than once per frame
		local rngdata = rng[frame]
		if rngdata ~= nil then
			Memory.write("rng", rngdata)
			print("Setting RNG to " .. rngdata)
			inc_segments = true
		end

		local globtdata = globt[frame]
		if globtdata ~= nil then
			Memory.write("globaltimer", Memory.read("globaltimer") + globtdata)
			print("Changing global timer by " .. globtdata)
			inc_segments = true
		end

		local otherdata = otherc[frame]
		if otherdata ~= nil then
			for index, value in ipairs(otherdata) do
				Memory.write(value[1], value[2])
				print("Setting " .. value[1] .. " to " .. value[2])
			end
			inc_segments = true
		end

		if inc_segments then
			segments = segments + 1
		end
	end

	Draw.author.author = findAuthor(frame, author, authoridx)

	prev_Joypad = Joypad
end

function atstop()
	if drawing then
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

vi = 0
frame = 0
a_presses = 0
segments = 1
prev_input = input.get() -- initialized here so there's no nil error later
Joypad = joypad.get(1)
prev_Joypad = { A = false }

if drawing then
	Screen.expand()
end

emu.atinterval(atinterval) -- ran continously
emu.atvi(atvi) -- ran every visual interupt (drawing happens here)
emu.atinput(atinput) -- ran every input frame
emu.atstop(atstop) -- ran when the script is stopped
