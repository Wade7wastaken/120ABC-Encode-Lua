Memory = {
	version = nil,
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
			name = "X"
		},
		marioy = {
			JP = 0x80339E40,
			US = 0x8033B1B0,
			size = 0,
			name = "Y"
		},
		marioz = {
			JP = 0x80339E44,
			US = 0x8033B1B4,
			size = 0,
			name = "Z"
		},
		action = {
			US = 0x8033B17C,
			JP = 0x80339E0C,
			size = 4,
			name = "Action"
		},
		hspeed = {
			US = 0x8033B1C4,
			JP = 0x80339E54,
			size = 0,
			name = "H Speed"
		},
		xslidespeed = {
			US = 0x8033B1C8,
			JP = 0x80339E58,
			size = 0,
			name = "X Slide Speed"
		},
		zslidespeed = {
			US = 0x8033B1CC,
			JP = 0x80339E5C,
			size = 0,
			name = "Z Slide Speed"
		},
		rng = {
			US = 0x8038EEE0,
			JP = 0x8038EEE0,
			size = 2,
			name = "RNG"
		},
		globaltimer = {
			US = 0x8032D5D4,
			JP = 0x8032C694,
			size = 4,
			name = "RNG"
		},
		holpx = {
			US = 0x8033B3C8,
			JP = 0x8033A058,
			size = 0,
			name = "HOLP X"
		},
		holpy = {
			US = 0x8033B3CC,
			JP = 0x8033A05C,
			size = 0,
			name = "HOLP Y"
		},
		holpz = {
			US = 0x8033B3D0,
			JP = 0x8033A060,
			size = 0,
			name = "HOLP Z"
		},
		angleface = {
			US = 0x8033B19E,
			JP = 0x80339E2E,
			size = 2,
			name = "Angle"
		},
		objpool = {
			US = 0x8033D488,
			JP = 0x8033C118,
			size = 4,
			name = "Object Pool Start Node"
		}
	},
	objmap = {
		next_obj = {addr = 0x08, size = 4}, -- {offset, size (0 is float)}
		X = {addr = 0xA0, size = 0}
	}
}
---@return integer|number
function Memory.read(location, s) -- s is for reading from decomp
	if Memory.addr[location] ~= nil then
		if Memory.addr[location].size == 0 then
			return memory.readfloat(Memory.addr[location][Memory.version])
		else
			return memory.readsize(Memory.addr[location][Memory.version], Memory.addr[location].size)
		end
	elseif Memory.decomp.addr[location] ~= nil then
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
		end
		
	else
		print("Failed to find memory location " .. location)
		return 0
	end
end

function Memory.write(location, value)
	if Memory.addr[location].size == 0 then
		memory.writefloat(Memory.addr[location][Memory.version], value)
	else
		memory.writesize(Memory.addr[location][Memory.version], Memory.addr[location].size, value)
	end
end

function Memory.getaddr(location)
	return Memory.addr[location][Memory.version]
end

function Memory.getobj(number)
	local id = (number - 1) % 240
	print(id)
	local ptr = Memory.getaddr("objpool")
	for i = 1, id do
		ptr = memory.readsize(ptr + Memory.objmap.next_obj.addr, 4)
	end
	return ptr
end

function Memory.getodata(number, attr)
	local data = Memory.objmap[attr]
	local ptr = Memory.getobj(number)
	if data[2] == 0 then
		return memory.readfloat(ptr + data[1])
	else
		return memory.readsize(ptr + data[1], data[2])
	end
end

function Memory.determineVersion() -- From InputDirection
	if memory.readsize(0x00B22B24, 4) == 1174429700 then -- JP
		return 'JP'
	else -- US
		return 'US'
	end
end

function Memory.loadDecompAddrs(version)
	local fname = PATH .. Memory.decomp["MapLocation" .. version]
	if not file_exists(fname) then
		print("File doesn't exist: " .. fname)
		return
	end
	for line in io.lines(fname) do
		local t = {}
		local l = line:gsub(",", " ") -- replace commas with spaces
		l = l:gsub("^%s*(.-)%s*$", "%1") -- trim the string
		
		sep = "%s" -- default seperator
		for str in string.gmatch(l, "([^".. sep .."]+)") do -- split the string into a table
			table.insert(t, str)
		end
		
		if #t ~= 2 then goto continue end
		if t[1]:sub(1, 10) ~= "0x00000000" then goto continue end
		
		t[1] = "0x" .. t[1]:sub(11) -- cut out the first 10 characters and add a "0x"
		
		Memory.decomp.addr[t[2]] = {addr = tonumber(t[1]), name = t[2]}
		
		::continue::
	end
end

function Memory.init()
	Memory.version = Memory.determineVersion()
	Memory.loadDecompAddrs("US")
end