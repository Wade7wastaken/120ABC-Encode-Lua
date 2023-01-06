function Round(x)
	return math.floor(x + 0.5)
end

function CopyTable(intable, outtable)
	for k, v in pairs(intable) do
		outtable[k] = v
	end
end

function CheckFileExists(file) -- checks if a file exists
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end