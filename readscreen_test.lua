local record_next_frame = 0

local function vi()
	if record_next_frame == 1 then
		wgui.deleteimage(0)
		wgui.loadscreen()
		record_next_frame = 0
	end
	wgui.drawimage(1, 0, 0, 0.5)
	--print("vi")
end

local function input()
	record_next_frame = 1
end

wgui.loadscreen()

emu.atvi(vi)
emu.atinput(input)
