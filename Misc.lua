---Rounds a number according to standard rounding rules
---@param a number|integer The number to be rounded
---@return integer output The rounded number
function Round(a)
	return math.floor(a + 0.5)
end

---Copies a table to another table
---@param intable table Input table
---@param outtable table Output table
function CopyTable(intable, outtable)
	for k, v in pairs(intable) do
		outtable[k] = v
	end
end

---Checks if a file exists
---@param filename string
---@return boolean Exists If the file exists
function CheckFileExists(filename) -- checks if a file exists
	local f = io.open(filename, "rb")
	if f then f:close() end
	return f ~= nil
end

---Serializes a table with or without formatting
---@param t table The input table to be Serialized
---@param format? string Whether the table should be formatted using string.format. The number of directives must equal the number of elements in `t`
---@return string serialized_table The serialized table
function SerializeLinearTable(t, format)
	local output = ""
	if format == nil then
		for i, v in ipairs(t) do
			output = output .. tostring(v)
			if i ~= #t then
				output = output .. " "
			end
		end
		return output
	else
		return string.format(format, table.unpack(t))
	end
end