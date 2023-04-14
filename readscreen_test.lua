-- 640 x 480

local record_next_frame = 0

local function vi()
	if record_next_frame == 1 then
		wgui.deleteimage(0)
		wgui.loadscreen()
		record_next_frame = 0
	end
	wgui.fillrecta(0, 0, 640, 480, "black")
	wgui.drawimage(1, 16, 12, 0.95)
	--print("vi")
end

local function input()
	record_next_frame = 1
end

wgui.loadscreen()

emu.atvi(vi)
emu.atinput(input)
