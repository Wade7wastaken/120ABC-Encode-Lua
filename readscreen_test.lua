

local function f()
	--wgui.loadscreen()
	--wgui.fillrecta(0, 0, 640, 480, "black")
	wgui.drawimage(1, 0, 0, 0.5)
	--wgui.deleteimage(0)
end

local function g()
	wgui.deleteimage(0)
	wgui.loadscreen()
end

wgui.loadscreen()

emu.atinput(f)
emu.atinput(g)
