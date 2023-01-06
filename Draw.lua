local m = Screen.height / 1080 -- Screen multiplier

Draw = {
	background = "#303030",
	backgrounda = "#303030FF",
	timer = {
		y = Round(m * 875),
		active = true,
		font_size = Round(m * 70),
		font = "Calibri",
		style = "a",
		color = "#FFFFFF",
		stopped_color = "#AAFFAA"
	},
	cstick = {
		x = Screen.start + Round(m * 240), -- 1680
		y = Round(m * 795),
		size = Round(m * 150),
		circle = {
			thickness = Round(m * 2),
			color = "#AAAAAA"
		},
		axis = {
			color = "#AAAAAA"
		},
		border = {
			thickness = Round(m * 3),
			color = "#FFFFFFFF"
		},
		stick = {
			thickness = Round(m * 3),
			color = "#FFAAAAFF"
		},
		ball = {
			radius = Round(m * 5),
			color = "#3333FFFF"
		},
		display = {
			x_offset = Round(m * 85),
			y_offset = Round(m * -27),
			distance = Round(m * 30),
			font_size = Round(m * 24),
			font = "Courier New",
			style = "ba",
			text_color = "#FF3333",
		}
	},
	buttons = {
		border = "#FFFFFFFF",
		text_color = "#FFFFFF",
		thickness = Round(m * 4)
	},
	a = {
		x = Screen.start + Round(m * 310), -- 1750
		y = Round(m * 650),
		radius = Round(m * 30),
		color = "#FF7777FF",
		font_size = Round(m * 32),
		font = "Calibri",
		style = "a",
		x_offset = Round(m * -11),
		y_offset = Round(m * -27)
	},
	b = {
		x = Screen.start + Round(m * 240), -- 1680
		y = Round(m * 650),
		radius = Round(m * 30),
		color = "#00C000FF",
		font_size = Round(m * 32),
		font = "Calibri",
		style = "a",
		x_offset = Round(m * -11),
		y_offset = Round(m * -27)
	},
	s = {
		x = Screen.start + Round(m * 275), -- 1715
		y = Round(m * 590),
		radius = Round(m * 30),
		color = "#4444FFFF",
		font_size = Round(m * 32),
		font = "Calibri",
		style = "a",
		x_offset = Round(m * -9),
		y_offset = Round(m * -27)
	},
	z = {
		x = Screen.start + Round(m * 160), -- 1600
		y = Round(m * 630),
		w = Round(m * 50),
		h = Round(m * 100),
		color = "#888888FF",
		font_size = Round(m * 32),
		font = "Calibri",
		style = "a",
		x_offset = Round(m * -11),
		y_offset = Round(m * -27)
	},
	cbuttons = {
		x = Screen.start + Round(m * 180), -- 1620
		y = Round(m * 500),
		radius = Round(m * 20),
		color = "#00FFFFFF",
		offset = Round(m * 40),
		text_color = "#FFFFFF",
		font_size = Round(m * 32),
		font = "Calibri",
		style = "a",
		text_offset = { Round(m * -12), Round(m * -26) },
		triangle_thickness = Round(m * 5),
		triangle_size = Round(m * 12)
	},
	r = {
		x = Screen.start + Round(m * 310), -- 1750
		y = Round(m * 500),
		w = Round(m * 100),
		h = Round(m * 50),
		color = "#888888FF",
		font_size = Round(m * 32),
		font = "Calibri",
		style = "a",
		x_offset = Round(m * -11),
		y_offset = Round(m * -27)
	},
	apress = {
		y = Round(m * 50),
		font_size = Round(m * 70),
		font = "Calibri",
		style = "a",
		text_color = "#FFFFFF",
		height = Round(m * 100),
		offset = Round(m * 100)
	},
	slots = {
		x = Screen.start + Round(m * 50), -- 1490
		start_y = Round(m * 260),
		y_offset = Round(m * 40),
		x_offset = Round(m * 190),
		font_size = Round(m * 24),
		font = "Calibri",
		style = "a",
		text_color = "#FFFFFF",
	},
	author = {
		author = "",
		y = Round(m * 985),
		font_size = Round(m * 24),
		font = "Calibri",
		style = "a",
		text_color = "#FFFFFF"
	}
}

---The main drawing function
function Draw.main()
	-- Clear the screen
	wgui.fillrecta(Screen.start, 0, Screen.extra_width, Screen.height, Draw.backgrounda)


	-- Draw timer
	wgui.setfont(Draw.timer.font_size, Draw.timer.font, Draw.timer.style)
	if Draw.timer.active then
		wgui.setcolor(Draw.timer.color)
		Draw.time = VI
	else
		wgui.setcolor(Draw.timer.stopped_color)
	end
	wgui.drawtext(Draw.calc_timer(Draw.time), { l = Screen.init_width, t = Draw.timer.y, w = Screen.extra_width, h = 200 },
		"c")


	-- Draw c stick
	Draw.circle_border(Draw.cstick.x, Draw.cstick.y, Draw.cstick.size / 2, Draw.cstick.circle.thickness, Draw.background,
		Draw.cstick.circle.color)

	-- Draw axes
	wgui.setpen(Draw.cstick.axis.color)
	wgui.line(Draw.cstick.x - (Draw.cstick.size / 2), Draw.cstick.y, Draw.cstick.x + (Draw.cstick.size / 2), Draw.cstick.y)
	wgui.line(Draw.cstick.x, Draw.cstick.y - (Draw.cstick.size / 2), Draw.cstick.x, Draw.cstick.y + (Draw.cstick.size / 2))

	-- Draw border
	Draw.border_transparent(Draw.cstick.x, Draw.cstick.y, Draw.cstick.size, Draw.cstick.size, Draw.cstick.border.thickness,
		Draw.cstick.border.color)

	-- Draw stick
	wgui.fillpolygona(Draw.calc_stick_points(), Draw.cstick.stick.color)
	Draw.fillcircle(Draw.cstick.x, Draw.cstick.y, Draw.cstick.stick.thickness, Draw.cstick.stick.color)

	-- Draw ball
	Draw.fillcircle(Draw.cstick.x + (Joypad.X * Round(Draw.cstick.size / 2) / 128),
		Draw.cstick.y - (Joypad.Y * Round(Draw.cstick.size / 2) / 128), Draw.cstick.ball.radius, Draw.cstick.ball.color)

	-- Draw c stick display
	wgui.setfont(Draw.cstick.display.font_size, Draw.cstick.display.font, Draw.cstick.display.style)
	wgui.setcolor(Draw.cstick.display.text_color)
	wgui.drawtext(string.format("X: %d", Joypad.X),
		{ l = Draw.cstick.x + Draw.cstick.display.x_offset, t = Draw.cstick.y + Draw.cstick.display.y_offset, w = 200, h = 30 }
		, "l")
	wgui.drawtext(string.format("Y: %d", Joypad.Y),
		{ l = Draw.cstick.x + Draw.cstick.display.x_offset,
			t = Draw.cstick.y + Draw.cstick.display.y_offset + Draw.cstick.display.distance, w = 200, h = 30 }, "l")


	-- Draw buttons
	Draw.button("a", "A", "A", 0) -- table name, joypad name, text, type
	Draw.button("b", "B", "B", 0)
	Draw.button("s", "start", "S", 0)
	Draw.button("z", "Z", "Z", 1)
	Draw.button("r", "R", "R", 1)


	-- Draw c buttons
	Draw.set_text("cbuttons")
	wgui.drawtext("C",
		{ l = Draw.cbuttons.x + Draw.cbuttons.text_offset[1], t = Draw.cbuttons.y + Draw.cbuttons.text_offset[2], w = 200,
			h = 100 }, "l")
	Draw.cbutton("Cup", { 0, -1 }, 0) -- joypad name, table with multipliers for the x and y offsets, angle
	Draw.cbutton("Cright", { 1, 0 }, -math.pi / 2) -- table example: {0, 0} means no offset, {1, 0} means x offset, {0, -1} means negative y offset
	Draw.cbutton("Cdown", { 0, 1 }, math.pi)
	Draw.cbutton("Cleft", { -1, 0 }, math.pi / 2)


	-- Draw a press counter
	Draw.set_text("apress")
	wgui.drawtext("A Presses:", { l = Screen.init_width, t = Draw.apress.y, w = Screen.extra_width, h = 100 }, "c")
	wgui.drawtext(string.format("%d", APresses),
		{ l = Screen.init_width, t = Draw.apress.y + Draw.apress.offset, w = Screen.extra_width, h = 100 }, "c")


	-- Draw variable slots and segment counter
	Draw.set_text("slots")
	wgui.drawtext("Segment", { l = Draw.slots.x, t = Draw.slots.start_y, w = Draw.slots.x_offset, h = 100 }, "l")
	wgui.drawtext(string.format("%d", Segments),
		{ l = Draw.slots.x + Draw.slots.x_offset, t = Draw.slots.start_y, w = 400, h = 100 }, "l")
	for i = 1, 3, 1 do
		if Slots[i].occupied then
			Draw.slot(i)
		end
	end
	Draw.set_text("author")
	wgui.drawtext("Author: " .. Draw.author.author,
		{ l = Screen.init_width, t = Draw.author.y, w = Screen.extra_width, h = 100 }, "c")
end

-- Shape drawing functions

---Draws a border around a rectangle using 4 draws, but doesn't overwrite the middle. The border is drawn on the inside of the rectangle
---@param x integer The x-coordinate in pixels of the middle of the rectangle from the top left of the screen
---@param y integer The y-coordinate in pixels of the middle of the rectangle from the top left of the screen
---@param w integer The width of the rectangle in pixels
---@param h integer The height of the rectangle in pixels
---@param thickness integer The size of the border in pixels. The border is drawn completely inside the rectangle
---@param color string The color of the border
function Draw.border_transparent(x, y, w, h, thickness, color)
	wgui.fillrecta(x - (w / 2), y - (h / 2), thickness, h, color)
	wgui.fillrecta(x - (w / 2) + thickness, y + (h / 2) - thickness, w - (thickness * 2), thickness, color)
	wgui.fillrecta(x + (w / 2) - thickness, y - (h / 2), thickness, h, color)
	wgui.fillrecta(x - (w / 2) + thickness, y - (h / 2), w - (thickness * 2), thickness, color)
end

---Draws a border around a rectangle using 2 draws. This function will overwrite the middle of the rectangle. The border is drawn on the inside of the rectangle
---@param x integer The x-coordinate in pixels of the middle of the rectangle from the top left of the screen
---@param y integer The y-coordinate in pixels of the middle of the rectangle from the top left of the screen
---@param w integer The width of the rectangle in pixels
---@param h integer The height of the rectangle in pixels
---@param thickness integer The size of the border in pixels. The border is drawn completely inside the rectangle
---@param inner_color string The color of the overwritten middle part of the rectangle
---@param border_color string The color of the border
function Draw.border(x, y, w, h, thickness, inner_color, border_color)
	wgui.fillrecta(x - (w / 2), y - (h / 2), w, h, border_color)
	wgui.fillrecta(x - (w / 2) + thickness, y - (h / 2) + thickness, w - (thickness * 2), h - (thickness * 2), inner_color)
end

---Draws a border around a circle in 2 draws. This function will overwrite the middle of the circle
---@param x integer The x-coordinate in pixels of the middle of the circle from the top left of the screen
---@param y integer The y-coordinate in pixels of the middle of the circle from the top left of the screen
---@param r integer The radius of the circle in pixels
---@param thickness integer The size of the border in pixels. The border is drawn completely inside the circle
---@param inner_color string The color of the overwritten middle part of the rectangle
---@param border_color string The color of the border
function Draw.circle_border(x, y, r, thickness, inner_color, border_color)
	wgui.fillellipsea(x - r, y - r, r * 2, r * 2, border_color)
	wgui.fillellipsea(x - r + thickness, y - r + thickness, (r - thickness) * 2, (r - thickness) * 2, inner_color)
end

---Draws a filled in circle
---@param x integer The x-coordinate in pixels of the middle of the circle from the top left of the screen
---@param y integer The y-coordinate in pixels of the middle of the circle from the top left of the screen
---@param r integer The radius of the circle in pixels
---@param color string The color of the circle
function Draw.fillcircle(x, y, r, color)
	wgui.fillellipsea(x - r, y - r, r * 2, r * 2, color)
end

function Draw.triangle(x, y, length, angle, thickness, inner_color, border_color) -- draws a triangle with a border
	wgui.fillpolygona({ {
		Round(x + (math.cos((math.pi / 2) + angle) * length)),
		Round(y - (math.sin((math.pi / 2) + angle) * length))
	}, {
		Round(x + (math.cos((7 / 6 * math.pi) + angle) * length)),
		Round(y - (math.sin((7 / 6 * math.pi) + angle) * length))
	}, {
		Round(x + (math.cos((11 / 6 * math.pi) + angle) * length)),
		Round(y - (math.sin((11 / 6 * math.pi) + angle) * length))
	} }, border_color)
	wgui.fillpolygona({ {
		Round(x + (math.cos((math.pi / 2) + angle) * (length - thickness))),
		Round(y - (math.sin((math.pi / 2) + angle) * (length - thickness)))
	}, {
		Round(x + (math.cos((7 / 6 * math.pi) + angle) * (length - thickness))),
		Round(y - (math.sin((7 / 6 * math.pi) + angle) * (length - thickness)))
	}, {
		Round(x + (math.cos((11 / 6 * math.pi) + angle) * (length - thickness))),
		Round(y - (math.sin((11 / 6 * math.pi) + angle) * (length - thickness)))
	} }, inner_color)
end

-- Complex drawing functions

function Draw.button(button, button_name, text, ty) -- Draws a button and text
	if ty == 0 then -- circle
		if Joypad[button_name] then
			Draw.circle_border(Draw[button].x, Draw[button].y, Draw[button].radius, Draw.buttons.thickness, Draw[button].color,
				Draw.buttons.border)
		else
			Draw.circle_border(Draw[button].x, Draw[button].y, Draw[button].radius, Draw.buttons.thickness, Draw.backgrounda,
				Draw.buttons.border)
		end
	end
	if ty == 1 then -- square
		if Joypad[button_name] then
			Draw.border(Draw[button].x, Draw[button].y, Draw[button].w, Draw[button].h, Draw.buttons.thickness,
				Draw[button].color, Draw.buttons.border)
		else
			Draw.border(Draw[button].x, Draw[button].y, Draw[button].w, Draw[button].h, Draw.buttons.thickness, Draw.backgrounda
				, Draw.buttons.border)
		end
	end
	wgui.setfont(Draw[button].font_size, Draw[button].font, Draw[button].style)
	wgui.setcolor(Draw.buttons.text_color)
	wgui.drawtext(text,
		{ l = Draw[button].x + Draw[button].x_offset, t = Draw[button].y + Draw[button].y_offset, w = 200, h = 100 }, "l")
end

function Draw.cbutton(joypad, offset_mult, angle)
	if Joypad[joypad] then
		Draw.circle_border(Draw.cbuttons.x + (Draw.cbuttons.offset * offset_mult[1]),
			Draw.cbuttons.y + (Draw.cbuttons.offset * offset_mult[2]), Draw.cbuttons.radius, Draw.buttons.thickness,
			Draw.cbuttons.color, Draw.buttons.border)
		Draw.triangle(Draw.cbuttons.x + (Draw.cbuttons.offset * offset_mult[1]),
			Draw.cbuttons.y + (Draw.cbuttons.offset * offset_mult[2]), Draw.cbuttons.triangle_size, angle,
			Draw.cbuttons.triangle_thickness, Draw.cbuttons.color, "black")
	else
		Draw.circle_border(Draw.cbuttons.x + (Draw.cbuttons.offset * offset_mult[1]),
			Draw.cbuttons.y + (Draw.cbuttons.offset * offset_mult[2]), Draw.cbuttons.radius, Draw.buttons.thickness,
			Draw.backgrounda, Draw.buttons.border)
		Draw.triangle(Draw.cbuttons.x + (Draw.cbuttons.offset * offset_mult[1]),
			Draw.cbuttons.y + (Draw.cbuttons.offset * offset_mult[2]), Draw.cbuttons.triangle_size, angle,
			Draw.cbuttons.triangle_thickness, Draw.backgrounda, Draw.buttons.border)
	end
end

function Draw.slot(slot)
	if Slots[slot].var == "holp" then
		wgui.drawtext("HOLP",
			{ l = Draw.slots.x, t = Draw.slots.start_y + (slot * Draw.slots.y_offset), w = Draw.slots.x_offset, h = 100 }, "l")
		wgui.drawtext(string.format("%.0f %.0f %.0f", Memory.read("holpx"), Memory.read("holpy"), Memory.read("holpz")),
			{ l = Draw.slots.x + Draw.slots.x_offset, t = Draw.slots.start_y + (slot * Draw.slots.y_offset), w = 400, h = 100 },
			"l")
	elseif Slots[slot].var == "slidespeed" then
		wgui.drawtext("Sliding Speed",
			{ l = Draw.slots.x, t = Draw.slots.start_y + (slot * Draw.slots.y_offset), w = Draw.slots.x_offset, h = 100 }, "l")
		wgui.drawtext(string.format("%.3f", math.sqrt(Memory.read("xslidespeed") ^ 2 + Memory.read("zslidespeed") ^ 2)),
			{ l = Draw.slots.x + Draw.slots.x_offset, t = Draw.slots.start_y + (slot * Draw.slots.y_offset), w = 400, h = 100 },
			"l")
	else
		wgui.drawtext(Memory.addr[Slots[slot].var].name,
			{ l = Draw.slots.x, t = Draw.slots.start_y + (slot * Draw.slots.y_offset), w = Draw.slots.x_offset, h = 100 }, "l")
		local style = nil
		if Memory.addr[Slots[slot].var].float then
			style = "%.3f"
		else
			style = "%d"
		end
		wgui.drawtext(string.format(style, Memory.read(Slots[slot].var)),
			{ l = Draw.slots.x + Draw.slots.x_offset, t = Draw.slots.start_y + (slot * Draw.slots.y_offset), w = 400, h = 100 },
			"l")
	end
end

-- Drawing utilities

function Draw.set_text(object)
	wgui.setfont(Draw[object].font_size, Draw[object].font, Draw[object].style)
	wgui.setcolor(Draw[object].text_color)
end

function Draw.calc_stick_points() -- calculates the points for the "stick" polygon
	-- finds the angle the stick makes with the x-axis
	-- adds and subtracts 2 pi to get the perpendicular angles
	local jx = Joypad.X * Round(Draw.cstick.size / 2) / 128
	local jy = Joypad.Y * Round(Draw.cstick.size / 2) / 128
	local anglep = math.atan(jy, jx) + (math.pi / 2)
	local anglem = math.atan(jy, jx) - (math.pi / 2)
	return { {
		Round(Draw.cstick.x + (math.cos(anglep) * Draw.cstick.stick.thickness)),
		Round(Draw.cstick.y - (math.sin(anglep) * Draw.cstick.stick.thickness))
	},
		{
			Round(Draw.cstick.x + (math.cos(anglep) * Draw.cstick.stick.thickness) + jx),
			Round(Draw.cstick.y - (math.sin(anglep) * Draw.cstick.stick.thickness) - jy)
		},
		{
			Round(Draw.cstick.x + (math.cos(anglem) * Draw.cstick.stick.thickness) + jx),
			Round(Draw.cstick.y - (math.sin(anglem) * Draw.cstick.stick.thickness) - jy)
		},
		{
			Round(Draw.cstick.x + (math.cos(anglem) * Draw.cstick.stick.thickness)),
			Round(Draw.cstick.y - (math.sin(anglem) * Draw.cstick.stick.thickness))
		} }
end

function Draw.calc_timer(vis) -- converts vi (60 fps) to h:m:s:ms
	local h = vis // 216000
	local m = (vis // 3600) - (h * 60)
	local s = (vis // 60) - (m * 60) - (h * 3600)
	local ms = Round((vis * 5 / 3) - (s * 100) - (m * 6000) - (h * 360000))
	return string.format("%02d:%02d:%02d.%02d", h, m, s, ms)
end
