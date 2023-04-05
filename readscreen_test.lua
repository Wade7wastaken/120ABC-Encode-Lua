-- 640x480
-- 576x432

local function f()
	wgui.loadscreen()
	wgui.fillrecta(0, 0, 640, 480, "black")
	wgui.drawimage(1, 40, 12, 576, 432)
	wgui.deleteimage(0)
	wgui.fillrecta(0, 0, 640, 480, "black")

end

emu.atvi(f)
