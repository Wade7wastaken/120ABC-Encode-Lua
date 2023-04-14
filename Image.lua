Image = {
	pool = {

	},
	alias = {
		mario = Path .. "Images/Mario Top.png",
		castle_grounds = Path .. "Images/Castle Grounds.png"
	},
	poolsize = 0,
	poolsizelimit = 50,
}

---Gets the filename from the alias name stored in `Image.alias`
---@param alias string
---@return string
local function get_fname(alias)
	if Image.alias[alias] ~= nil then
		return Image.alias[alias]
	else
		return alias
	end
end


---Gets the index of the image `fname`. `fname` can be a path, or an alias defined in `Image.alias`
---@param fname string
---@return integer
function Image.get(fname)
	local name = get_fname(fname)
	if Image.pool[name] == nil then
		if Image.poolsize >= Image.poolsizelimit then
			wgui.deleteimage(0)
			Image.poolsize = 0
			Image.pool = {}
			print("deleting images")
		end


		Image.pool[name] = wgui.loadimage(name)
		Image.poolsize = Image.poolsize + 1

		print("loading: " .. name)
		print(Image.poolsize)
		print(Image.pool)
	end
	return Image.pool[name]
end

function Image.getinfo(fname)
	local name = get_fname(fname)
	if Image.pool[name] == nil then
		Image.pool[name] = wgui.loadimage(name)
	end
	return wgui.getimageinfo(Image[name])
end
