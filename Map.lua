--[[
Images:
Map Background (1)
Map Icons (idk yet)
]]

--[[
States:
0: inactive
1: game inset
2: map
3: custom camera location
4: relative camera (visible PUs)
5: PU map
]]

local imagesize = 1500 -- the size of the map images
local iconscale = 0.25

local template = {
	state = 0,
	data = {},
	x = 0,
	y = 0,
	w = 500,
	h = 500,
	border = { size = 5, color = "#FFFFFFFF" },
	background = "#000000FF"
}

Map = {
	map1 = {},
	map2 = {},
	map3 = {},
	map4 = {}
}

function Map.init()
	CopyTable(template, Map.map1)
	CopyTable(template, Map.map2)
	CopyTable(template, Map.map3)
	CopyTable(template, Map.map4)

	--wgui.loadimage(PATH .. "Maps\\Lua Maps\\Castle Grounds.png")
	--wgui.loadimage(PATH .. "Maps\\Mario Top.png")
end

Map.init()

function Map.draw()
	for i = 1, 4 do
		local data = Map["map" .. i]
		if data.state == 0 then goto continue end
		if data.state == 1 then goto continue end
		if data.state == 2 then
			data.w = input.get().xmouse
			data.h = input.get().ymouse

			-- draw background
			wgui.fillrecta(data.x - data.border.size, data.y - data.border.size, data.w + (2 * data.border.size),
				data.h + (2 * data.border.size), data.border.color)
			wgui.fillrecta(data.x, data.y, data.w, data.h, data.background)

			-- render map
			local mapfname = "Images/Maps/" .. data.data.name .. ".png"

			local imageinfo = Image.getinfo(mapfname)

			-- aspect ratio
			--if data.w > data.h then
			--local ar = data.w / data.h
			--else
			--local ar = data.h / data.w
			--end

			local ar = math.max(data.w, data.h) / math.min(data.w, data.h)
			print(ar)

			wgui.drawimage(Image.get(mapfname), data.x, data.y, data.w, data.h,
				data.data.x - (imagesize / (2 * data.data.zoom)), data.data.y - (imagesize / (2 * data.data.zoom * ar)),
				(imagesize / data.data.zoom), (imagesize / (ar * data.data.zoom)), 0)

			if data.data.mario == true then
				local fname = "Images/Objects/Mario Top.png"
				local v = imagesize / (data.w * data.data.zoom)
				wgui.drawimage(Image.get(fname),
					Round((
						((((imagesize / (2 * data.data.zoom)) - data.data.x) / v) + data.x) +
							((375 * (Memory.read("mariox") + 8191)) / (4096 * v))) - (Image.getinfo(fname).width * iconscale / 2)),
					Round((
						((((imagesize / (2 * ar * data.data.zoom)) - data.data.y) / v) + data.y) +
							((375 * (Memory.read("marioz") + 8191)) / (4096 * v))) - (Image.getinfo(fname).height * iconscale / 2)),
					iconscale)
			end
		end

		::continue::
	end

end

function Map.deactivate(idx)
	Map["map" .. idx] = template
end

Map.deactivateAll = Map.init
