Memory = {
	---@type "JP"|"US"
	version = nil, -- default to US
	addr = {
		mariox = {
			JP = 0x80339E3C,
			US = 0x8033B1AC,
			size = 0,
			DisplayName = "X",
		},
		marioy = {
			JP = 0x80339E40,
			US = 0x8033B1B0,
			size = 0,
			DisplayName = "Y",
		},
		marioz = {
			JP = 0x80339E44,
			US = 0x8033B1B4,
			size = 0,
			DisplayName = "Z",
		},
		action = {
			US = 0x8033B17C,
			JP = 0x80339E0C,
			size = 4,
			DisplayName = "Action",
		},
		hspeed = {
			US = 0x8033B1C4,
			JP = 0x80339E54,
			size = 0,
			DisplayName = "H Speed",
		},
		xslidespeed = {
			US = 0x8033B1C8,
			JP = 0x80339E58,
			size = 0,
			DisplayName = "X Slide Speed",
		},
		zslidespeed = {
			US = 0x8033B1CC,
			JP = 0x80339E5C,
			size = 0,
			DisplayName = "Z Slide Speed",
		},
		rng = {
			US = 0x8038EEE0,
			JP = 0x8038EEE0,
			size = 2,
			DisplayName = "RNG",
		},
		globaltimer = {
			US = 0x8032D5D4,
			JP = 0x8032C694,
			size = 4,
			DisplayName = "RNG",
		},
		holpx = {
			US = 0x8033B3C8,
			JP = 0x8033A058,
			size = 0,
			DisplayName = "HOLP X",
		},
		holpy = {
			US = 0x8033B3CC,
			JP = 0x8033A05C,
			size = 0,
			DisplayName = "HOLP Y",
		},
		holpz = {
			US = 0x8033B3D0,
			JP = 0x8033A060,
			size = 0,
			DisplayName = "HOLP Z",
		},
		angleface = {
			US = 0x8033B19E,
			JP = 0x80339E2E,
			size = 2,
			DisplayName = "Angle",
		},
		objpool = {
			US = 0x8033D488,
			JP = 0x8033C118,
			size = 4,
			DisplayName = "Object Pool Start Node",
		},
	},
	special = {
		-- special memory functions
		hslidespeed = {
			process = function(t)
				return math.sqrt((t[1] ^ 2) + (t[2] ^ 2))
			end,
			parameters = {"xslidespeed", "zslidespeed",},
			DisplayName = "H Slide Speed",
		},
		holp = {
			process = function(t)
				return t
			end,
			parameters = {"holpx", "holpy", "holpz",},
			DisplayName = "HOLP",
		},
	},
	objmap = {
		next_obj = {addr = 0x08, size = 4,}, -- {offset, size (0 is float)}
		X = {addr = 0xA0, size = 0,},
	},
}
---Reads a value from memory. Location is a variable in Memory.addr or Memory.special
---@param location string The name of the variable to read from memory
---@return integer|number|string|table
function Memory.read(location)
	if Memory.addr[location] ~= nil then
		if Memory.addr[location].size == 0 then
			return memory.readfloat(Memory.addr[location][Memory.version])
		else
			return memory.readsize(Memory.addr[location][Memory.version],
			Memory.addr[location].size)
		end
	elseif Memory.special[location] ~= nil then
		local t = {}
		for _, value in ipairs(Memory.special[location].parameters) do
			table.insert(t, Memory.read(value))
		end
		return Memory.special[location].process(t)
	else
		print("Failed to find memory location " .. location .. ". Returning 0")
		return 0
	end
end

---Writes a value to memory. Location is a variable in Memory.addr or Memory.special
---@param location string The name of the variable to write to memory
---@param value integer|number The value to write to memory
---@return integer|nil
function Memory.write(location, value)
	if Memory.addr[location] ~= nil then
		if Memory.addr[location].size == 0 then
			memory.writefloat(Memory.addr[location][Memory.version], value)
		else
			memory.writesize(Memory.addr[location][Memory.version],
			Memory.addr[location].size, value)
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
	elseif Memory.special[location] ~= nil then
		return Memory.special[location].DisplayName
	else
		print("Failed to find memory location " .. location .. ". Returning \"\"")
		return ""
	end
end

---Returns the memory address of a given variable.
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
	for _ = 1, id do
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
function Memory.determine_version() -- From InputDirection
	if memory.readsize(0x00B22B24, 4) == 1174429700 then -- JP
		return "JP"
	else -- US
		return "US"
	end
end

---Initializes the Memory module
local function init()
	Memory.version = Memory.determine_version()
end

init()
