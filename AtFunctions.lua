---This function is run continuously
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
		print("Toggled drawing")
	end

	-- reset the a press counter if the home button is pressed
	if InputDiff.home then
		print("Resetting A press counter")
		APresses = 0
	end

	-- set the previous input for the next frame
	PreviousInput = current_input
end

---This function is run for every VI
function AtVI()
	VI = emu.framecount() + 1 -- ¯\_(ツ)_/¯

	if DRAWING then
		Draw.main() -- main draw loop. Very important to keep in vi, not interval, so it syncs when dumping avi
		--Map.draw() -- a special version of mupen is required for this function https://github.com/Wade7wastaken/mupen64-rr-lua-/tree/dev
	end
end

---This function is run for every input frame
function AtInput()
	--print(memory.readsize(
	--memory.readsize(WafelData.globals.gMarioState.address, 4) +
	--WafelData.type_defns["struct MarioState"].data.fields.action.offset, 4))
	Frame = emu.samplecount() + 1 -- ¯\_(ツ)_/¯
	Joypad = joypad.get(1) -- get the joypad input from the first controller
	if Joypad.A and not PreviousJoypad.A then -- a press counter logic (cant use input.diff for some reason)
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
			Memory.write("globaltimer",
				Memory.read("globaltimer") + global_timer_data)
			print("Changing global timer by " .. global_timer_data)
			inc_segments = true
		end

		local other_data = OtherChanges[Frame]
		if other_data ~= nil then
			-- loop over all the changes in other_data
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
	local prev_author = nil -- the previously checked frame
	for _, value in ipairs(AuthorIndices) do -- for every author change in the index table
		if Frame < value then -- if the frame of that author change if more than the current frame
			Draw.author.author = AuthorChanges
				[prev_author] -- set the author to the previous author change
			break
		end
		prev_author = value
	end

	-- return the last author change if the loop finishes
	if Draw.author.author == nil then
		Draw.author.author = AuthorChanges[AuthorIndices[#AuthorIndices]]
	end

	Draw.slots.data = {{name = "", value = ""}, {name = "", value = ""},
		{name = "", value = ""},} -- clear the slots
	for _, value in ipairs(SlotIndices) do
		if Frame < value then break end
		for _, value2 in ipairs(SlotChanges[value]) do
			if value2[2] ~= "" then
				Draw.slots.data[value2[1]].name = Memory.get_display_name(value2
					[2])

				local mem = Memory.read(value2[2])

				local fmt = value2[3]

				local p = (type(mem) == "table") -- did Memory return a table?
				local q = (fmt ~= nil) -- is there formatting data?
				local output = ""

				if p and q then
					assert(type(mem) == "table") -- we have to assert this so annotations don't freak out
					output = SerializeLinearTable(mem, fmt)
				elseif p and not q then
					assert(type(mem) == "table")
					output = SerializeLinearTable(mem)
				elseif not p and q then
					output = string.format(fmt, mem)
				elseif not p and not q then
					output = tostring(mem)
				end
				Draw.slots.data[value2[1]].value = output
			else
				Draw.slots.data[value2[1]].name = ""
				Draw.slots.data[value2[1]].value = ""
			end
		end
	end

	if Memory.read("action") == 6409 then -- end cutscene action
		Draw.timer.active = false -- stop the timer when the grand star is collected
	end

	PreviousJoypad = Joypad
end

---This function is run when the lua program is stopped
function AtStop()
	if DRAWING then
		Screen.contract()
	end
end

---This function is run when the emulator is reset
function AtReset()
	-- expand the screen because it is reset to the default values when the emulator is reset
	Screen.expand()
end
