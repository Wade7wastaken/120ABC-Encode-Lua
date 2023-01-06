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
