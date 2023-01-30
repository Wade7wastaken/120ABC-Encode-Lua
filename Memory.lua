Memory = {
	---@type "JP"|"US"
	version = "US", -- default to US
	decomp = { -- addresses from decomp map file
		MapLocationUS = "Mappings/MappingUS.map",
		MapLocationJP = "Mappings/MappingJP.map",
		addr = {}
	},
	addr = {
		mariox = {
			JP = 0x80339E3C,
			US = 0x8033B1AC,
			size = 0,
			DisplayName = "X"
		},
		marioy = {
			JP = 0x80339E40,
			US = 0x8033B1B0,
			size = 0,
			DisplayName = "Y"
		},
		marioz = {
			JP = 0x80339E44,
			US = 0x8033B1B4,
			size = 0,
			DisplayName = "Z"
		},
		action = {
			US = 0x8033B17C,
			JP = 0x80339E0C,
			size = 4,
			DisplayName = "Action"
		},
		hspeed = {
			US = 0x8033B1C4,
			JP = 0x80339E54,
			size = 0,
			DisplayName = "H Speed"
		},
		xslidespeed = {
			US = 0x8033B1C8,
			JP = 0x80339E58,
			size = 0,
			DisplayName = "X Slide Speed"
		},
		zslidespeed = {
			US = 0x8033B1CC,
			JP = 0x80339E5C,
			size = 0,
			DisplayName = "Z Slide Speed"
		},
		rng = {
			US = 0x8038EEE0,
			JP = 0x8038EEE0,
			size = 2,
			DisplayName = "RNG"
		},
		globaltimer = {
			US = 0x8032D5D4,
			JP = 0x8032C694,
			size = 4,
			DisplayName = "RNG"
		},
		holpx = {
			US = 0x8033B3C8,
			JP = 0x8033A058,
			size = 0,
			DisplayName = "HOLP X"
		},
		holpy = {
			US = 0x8033B3CC,
			JP = 0x8033A05C,
			size = 0,
			DisplayName = "HOLP Y"
		},
		holpz = {
			US = 0x8033B3D0,
			JP = 0x8033A060,
			size = 0,
			DisplayName = "HOLP Z"
		},
		angleface = {
			US = 0x8033B19E,
			JP = 0x80339E2E,
			size = 2,
			DisplayName = "Angle"
		},
		objpool = {
			US = 0x8033D488,
			JP = 0x8033C118,
			size = 4,
			DisplayName = "Object Pool Start Node"
		}
	},
	special = { -- special memory functions
		hslidespeed = {
			process = function(t)
				return math.sqrt((t[1] ^ 2) + (t[2] ^ 2))
			end,
			parameters = { "xslidespeed", "zslidespeed" },
			DisplayName = "H Slide Speed"
		},
		holp = {
			process = function(t)
				return t
			end,
			parameters = { "holpx", "holpy", "holpz" },
			DisplayName = "HOLP"
		}
	},
	objmap = {
		next_obj = { addr = 0x08, size = 4 }, -- {offset, size (0 is float)}
		X = { addr = 0xA0, size = 0 }
	}
}
---Reads a value from memory. Location can be an sm64 decomp variable or a custom defined variable in Memory.addr
---@param location string The name of the variable to read from memory
---@param s? integer The size of a variable read from decomp. A value of "0" means to read a float
---@return integer|number|string|table
function Memory.read(location, s)
	if Memory.addr[location] ~= nil then
		if Memory.addr[location].size == 0 then
			return memory.readfloat(Memory.addr[location][Memory.version])
		else
			return memory.readsize(Memory.addr[location][Memory.version], Memory.addr[location].size)
		end
		--[[elseif Memory.decomp.addr[location] ~= nil then
		local size
		if Memory.decomp.addr[location].size ~= nil then size = Memory.decomp.addr[location].size end
		if s ~= nil then size = s end -- prioritize this

		if size == nil then
			print("Size for " .. location .. "could not be found. Using 4 byte non-float")
			size = 4
		end

		if size == 0 then
			return memory.readfloat(Memory.decomp.addr[location].addr)
		else
			return memory.readsize(Memory.decomp.addr[location].addr, size)
		end]]

	elseif Memory.special[location] ~= nil then
		local t = {}
		for _, v in ipairs(Memory.special[location].parameters) do
			table.insert(t, Memory.read(v))
		end
		return Memory.special[location].process(t)
	else
		local path = string.format("\"%sPython\\WafelRead\\dist\\WafelRead.exe\" %d %d %s %s", PATH, System.pid,
			System.ramstart, Memory.version:lower(), location)

		local handle = io.popen(path)
		if handle ~= nil then
			local result = handle:read("a")
			handle:close()

			local words = SplitString(result)

			if words[1] == "Ok" then
				local cast = tonumber(words[2])
				if cast ~= nil then
					return cast
				else
					print("Error casting")
				end
			elseif words[1] == "Error" then
				print("Error reading from " .. location .. ". Error: " .. words[2] .. " " .. table.concat(words, " ", 3, #words))
			else
				print("Unknown result, reading " .. location .. ": " .. result)
				return 0
			end

		else
			print("Failed to run command " .. path .. ". Resulting handle was nil.")
			return 0
		end
	end
	return 0
end

---Writes a value to memory. Location can be an sm64 decomp variable or a custom defined variable in Memory.addr
---@param location string The name of the variable to write to memory
---@param value integer|number The value to write to memory
---@param s? integer The size of a variable red from decomp. A value of "0" means to read a float
---@return integer|nil
function Memory.write(location, value, s)
	if Memory.addr[location] ~= nil then
		if Memory.addr[location].size == 0 then
			memory.writefloat(Memory.addr[location][Memory.version], value)
		else
			memory.writesize(Memory.addr[location][Memory.version], Memory.addr[location].size, value)
		end
	elseif Memory.decomp.addr[location] ~= nil then
		local size
		if Memory.decomp.addr[location].size ~= nil then size = Memory.decomp.addr[location].size end
		if s ~= nil then size = s end

		if size == nil then
			print("Size for " .. location .. "could not be found. Using 4 byte non-float")
			size = 4
		end

		if size == 0 then
			memory.writefloat(Memory.decomp.addr[location].addr, value)
		else
			memory.writesize(Memory.decomp.addr[location].addr, size, value)
		end
	else
		print("Failed to find memory location " .. location)
		return 0
	end
end

---Returns the display name of the variable at location
---@param location string The name of the variable
---@return string display_name The display name of the variable
function Memory.get_display_name(location)
	if Memory.addr[location] ~= nil then
		return Memory.addr[location].DisplayName
	elseif Memory.decomp.addr[location] ~= nil then
		return Memory.decomp.addr[location].name
	elseif Memory.special[location] ~= nil then
		return Memory.special[location].DisplayName
	else
		print("Failed to find memory location " .. location)
		return ""
	end
end

---Returns the memory address of a given variable. (Does not support decomp variables yet)
---@param location string The name of the variable
---@return integer
function Memory.get_addr(location)
	-- I have to do it this weird way because "return Memory.addr[location][Memory.version]" doesn't comply with the annotations (even though it totally does)
	if Memory.version == "US" then
		return Memory.addr[location].US
	else
		return Memory.addr[location].JP
	end
end

---Returns an address pointing to an object with a certain index
---@param index integer The index of an object. Note that this index is in Memory Order in STROOP and not Processing Order
---@return integer ptr A pointer to an object with a certain index
function Memory.get_obj_ptr(index)
	local id = (index - 1) % 240
	local ptr = Memory.get_addr("objpool")
	for i = 1, id do
		ptr = memory.readsize(ptr + Memory.objmap.next_obj.addr, 4)
	end
	return ptr
end

---Returns a given attribute from an object at a certain position
---@param index integer
---@param attr string
---@return integer|number
function Memory.get_object_data(index, attr)
	local data = Memory.objmap[attr]
	local ptr = Memory.get_obj_ptr(index)
	if data.size == 0 then
		return memory.readfloat(ptr + data[1])
	else
		return memory.readsize(ptr + data[1], data[2])
	end
end

---Determines the SM64 version this script is being run on
---@return "US"|"JP"
function Memory.determineVersion() -- From InputDirection
	if memory.readsize(0x00B22B24, 4) == 1174429700 then -- JP
		return "JP"
	else -- US
		return "US"
	end
end

---Loads variables from a .map file generated by decomp. They are loaded into Memory.decomp.addr
---@param version "US"|"JP"
function Memory.loadDecompAddrs(version)
	local fname = PATH .. Memory.decomp["MapLocation" .. version]
	if not CheckFileExists(fname) then
		print("File doesn't exist: " .. fname)
		return
	end
	for line in io.lines(fname) do
		local t = {}
		local l = line:gsub(",", " ") -- replace commas with spaces
		l = l:gsub("^%s*(.-)%s*$", "%1") -- trim the string

		local sep = "%s" -- default seperator
		for str in string.gmatch(l, "([^" .. sep .. "]+)") do -- split the string into a table
			table.insert(t, str)
		end

		if #t ~= 2 then goto continue end
		if t[1]:sub(1, 10) ~= "0x00000000" then goto continue end

		t[1] = "0x" .. t[1]:sub(11) -- cut out the first 10 characters and add a "0x"

		Memory.decomp.addr[t[2]] = { addr = tonumber(t[1]), name = t[2] }

		::continue::
	end
end

---Initializes the Memory module
function Memory.init()
	Memory.version = Memory.determineVersion()
	Memory.loadDecompAddrs(Memory.version)
end
