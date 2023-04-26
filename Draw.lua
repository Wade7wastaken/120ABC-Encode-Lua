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
		stopped_color = "#AAFFAA",
	},
	cstick = {
		x = Screen.start + Round(m * 165), -- 1680
		y = Round(m * 720),
		size = Round(m * 150),
		circle = {
			thickness = Round(m * 2),
			color = "#AAAAAA",
		},
		axis = {
			color = "#AAAAAA",
		},
		border = {
			thickness = Round(m * 3),
			color = "#FFFFFFFF",
		},
		stick = {
			thickness = Round(m * 3),
			color = "#FFAAAAFF",
		},
		ball = {
			radius = Round(m * 5),
			color = "#3333FFFF",
		},
		display = {
			x_offset = Round(m * 160),
			y_offset = Round(m * 48),
			distance = Round(m * 30),
			font_size = Round(m * 24),
			font = "Courier New",
			style = "ba",
			text_color = "#FF3333",
		},
	},
	buttons = {
		border = "#FFFFFFFF",
		text_color = "#FFFFFF",
		thickness = Round(m * 4),
	},
	a = {
		x = Screen.start + Round(m * 280), -- 1750
		y = Round(m * 620),
		radius = Round(m * 30),
		color = "#FF7777FF",
		font_size = Round(m * 32),
		font = "Calibri",
		style = "a",
		x_offset = Round(m * 18),
		y_offset = Round(m * 3),
	},
	b = {
		x = Screen.start + Round(m * 210), -- 1680
		y = Round(m * 620),
		radius = Round(m * 30),
		color = "#00C000FF",
		font_size = Round(m * 32),
		font = "Calibri",
		style = "a",
		x_offset = Round(m * 18),
		y_offset = Round(m * 3),
	},
	s = {
		x = Screen.start + Round(m * 245), -- 1715
		y = Round(m * 560),
		radius = Round(m * 30),
		color = "#4444FFFF",
		font_size = Round(m * 32),
		font = "Calibri",
		style = "a",
		x_offset = Round(m * 20),
		y_offset = Round(m * 3),
	},
	z = {
		x = Screen.start + Round(m * 135), -- 1600
		y = Round(m * 580),
		w = Round(m * 50),
		h = Round(m * 100),
		color = "#888888FF",
		font_size = Round(m * 32),
		font = "Calibri",
		style = "a",
		x_offset = Round(m * 15),
		y_offset = Round(m * 20),
	},
	cbuttons = {
		-- these coordinates are the center of the buttons because it makes everything easier
		x = Screen.start + Round(m * 180), -- 1620
		y = Round(m * 500),
		radius = Round(m * 20),
		color = "#00FFFFFF",
		offset = Round(m * 40),
		text_color = "#FFFFFF",
		font_size = Round(m * 32),
		font = "Calibri",
		style = "a",
		text_offset = {Round(m * -12), Round(m * -26)},
		triangle_thickness = Round(m * 5),
		triangle_size = Round(m * 12),
	},
	r = {
		x = Screen.start + Round(m * 260), -- 1750
		y = Round(m * 475),
		w = Round(m * 100),
		h = Round(m * 50),
		color = "#888888FF",
		font_size = Round(m * 32),
		font = "Calibri",
		style = "a",
		x_offset = Round(m * 38),
		y_offset = Round(m * -1),
	},
	apress = {
		y = Round(m * 50),
		font_size = Round(m * 70),
		font = "Calibri",
		style = "a",
		text_color = "#FFFFFF",
		height = Round(m * 100),
		offset = Round(m * 100),
	},
	slots = {
		data = {
			{name = "", value = ""},
			{name = "", value = ""},
			{name = "", value = ""},
		},
		x = Screen.start + Round(m * 50), -- 1490
		start_y = Round(m * 260),
		y_offset = Round(m * 40),
		x_offset = Round(m * 190), -- the distance between the name and the value
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
		text_color = "#FFFFFF",
	},
	notes = {
		background = "#000000",
		width = Round(m * 400),
		height = Round(m * 250),
		border_color = "#FFFFFF",
		border_thickness = Round(m * 4),
		current_offset = 0,
		state = 0, -- 0: hidden, 1: expanding, 2: displaying, 3: retracting
	},
}

-- Drawing utilities

---Sets the font and text color for a given object
---@param object string The table in the Draw table that contains the font information
local function set_text(object)
	wgui.setfont(Draw[object].font_size, Draw[object].font, Draw[object].style)
	wgui.setcolor(Draw[object].text_color)
end

---Calculates the points for the "stick" polygon
---@return table
local function calc_stick_points()
	-- Normalizes the joystick and multiplies by half of the size of the cstick box to get the coordinates of the endpoint of the joystick
	local jx = Joypad.X / 128 * Round(Draw.cstick.size / 2)
	local jy = Joypad.Y / 128 * Round(Draw.cstick.size / 2)
	local anglep = math.atan(jy, jx) + (math.pi / 2)
	local anglem = math.atan(jy, jx) - (math.pi / 2)
	return {
		{
			Round(Draw.cstick.x + (Draw.cstick.size / 2) +
				(math.cos(anglep) * Draw.cstick.stick.thickness)),
			Round(Draw.cstick.y + (Draw.cstick.size / 2) -
				(math.sin(anglep) * Draw.cstick.stick.thickness)),
		},
		{
			Round(Draw.cstick.x + (Draw.cstick.size / 2) +
				(math.cos(anglep) * Draw.cstick.stick.thickness) + jx),
			Round(Draw.cstick.y + (Draw.cstick.size / 2) -
				(math.sin(anglep) * Draw.cstick.stick.thickness) - jy),
		},
		{
			Round(Draw.cstick.x + (Draw.cstick.size / 2) +
				(math.cos(anglem) * Draw.cstick.stick.thickness) + jx),
			Round(Draw.cstick.y + (Draw.cstick.size / 2) -
				(math.sin(anglem) * Draw.cstick.stick.thickness) - jy),
		},
		{
			Round(Draw.cstick.x + (Draw.cstick.size / 2) +
				(math.cos(anglem) * Draw.cstick.stick.thickness)),
			Round(Draw.cstick.y + (Draw.cstick.size / 2) -
				(math.sin(anglem) * Draw.cstick.stick.thickness)),
		},
	}
end

-- Shape drawing functions

---DONE Draws a border around a rectangle using 4 draws, but doesn't overwrite the middle. The border is drawn on the inside of the rectangle
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param t integer
---@param color string
local function border_transparent(x, y, w, h, t, color)
	wgui.fillrecta(x, y, t, h, color)
	wgui.fillrecta(x + t, y + h - t, w - (2 * t), t, color)
	wgui.fillrecta(x + w - t, y, t, h, color)
	wgui.fillrecta(x + t, y, w - (2 * t), t, color)
end

---DONE Draws a border around a rectangle using 2 draws. This function will overwrite the middle of the rectangle. The border is drawn on the inside of the rectangle
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param t integer
---@param inner_color string
---@param border_color string
local function border(x, y, w, h, t, inner_color, border_color)
	wgui.fillrecta(x, y, w, h, border_color)
	wgui.fillrecta(x + t, y + t, w - (2 * t), h - (2 * t), inner_color)
end

---DONE Draws a border around a circle in 2 draws. This function will overwrite the middle of the circle
---@param x integer
---@param y integer
---@param r integer
---@param t integer
---@param inner_color string
---@param border_color string
local function circle_border(x, y, r, t, inner_color, border_color)
	local d = 2 * r
	wgui.fillellipsea(x, y, d, d, border_color)
	wgui.fillellipsea(x + t, y + t, d - (t * 2), d - (t * 2), inner_color)
end

---DONE Draws a filled in circle
---@param x integer The x-coordinate in pixels of the middle of the circle from the top left of the screen
---@param y integer The y-coordinate in pixels of the middle of the circle from the top left of the screen
---@param r integer The radius of the circle in pixels
---@param color string The color of the circle
local function fill_circle(x, y, r, color)
	wgui.fillellipsea(x, y, r * 2, r * 2, color)
end

---Draws the border of an equilateral triangle. This function will overwrite the middle of the triangle
---@param x integer The x-coordinate of the center of the triangle
---@param y integer The y-coordinate of the center of the triangle
---@param length integer The length of the triangle's side lengths
---@param angle integer|number The angle in radians that the triangle is rotated
---@param thickness integer The thickness of the border
---@param inner_color string The color of the middle of the triangle
---@param border_color string The color of the border
local function triangle(x, y, length, angle, thickness, inner_color, border_color) -- draws a triangle with a border
	wgui.fillpolygona(
		{
			{
				Round(x + (math.cos((math.pi / 2) + angle) * length)),
				Round(y - (math.sin((math.pi / 2) + angle) * length)),
			},
			{
				Round(x + (math.cos((7 / 6 * math.pi) + angle) * length)),
				Round(y - (math.sin((7 / 6 * math.pi) + angle) * length)),
			},
			{
				Round(x + (math.cos((11 / 6 * math.pi) + angle) * length)),
				Round(y - (math.sin((11 / 6 * math.pi) + angle) * length)),
			},
		},
		border_color)
	wgui.fillpolygona(
		{
			{
				Round(x +
					(math.cos((math.pi / 2) + angle) * (length - thickness))),
				Round(y -
					(math.sin((math.pi / 2) + angle) * (length - thickness))),
			},
			{
				Round(x +
					(math.cos((7 / 6 * math.pi) + angle) * (length - thickness))),
				Round(y -
					(math.sin((7 / 6 * math.pi) + angle) * (length - thickness))),
			},
			{
				Round(x +
					(math.cos((11 / 6 * math.pi) + angle) * (length - thickness))),
				Round(y -
					(math.sin((11 / 6 * math.pi) + angle) * (length - thickness))),
			},
		},
		inner_color)
end

-- Complex drawing functions

---Draws a circular or square button
---@param table_name string The name of the table in Draw to draw the button
---@param joypad_name string The name of the field in the Joypad table
---@param text any
---@param type any
local function button_all(table_name, joypad_name, text, type)
	if type == 0 then -- circle
		if Joypad[joypad_name] then -- If the button is being pressed
			circle_border(
				Draw[table_name].x, Draw[table_name].y, Draw[table_name].radius,
				Draw.buttons.thickness, Draw[table_name].color,
				Draw.buttons.border
			)
		else -- if the button isn't being pressed
			circle_border(
				Draw[table_name].x, Draw[table_name].y, Draw[table_name].radius,
				Draw.buttons.thickness, Draw.backgrounda, Draw.buttons.border
			)
		end
	end
	if type == 1 then -- square
		if Joypad[joypad_name] then -- If the button is being pressed
			border(
				Draw[table_name].x, Draw[table_name].y, Draw[table_name].w,
				Draw[table_name].h, Draw.buttons.thickness,
				Draw[table_name].color, Draw.buttons.border
			)
		else -- If the button isn't being pressed
			border(
				Draw[table_name].x, Draw[table_name].y, Draw[table_name].w,
				Draw[table_name].h, Draw.buttons.thickness, Draw.backgrounda,
				Draw.buttons.border
			)
		end
	end
	wgui.setfont(Draw[table_name].font_size, Draw[table_name].font,
		Draw[table_name].style)
	wgui.setcolor(Draw.buttons.text_color)
	wgui.drawtext(text,
		{
			l = Draw[table_name].x + Draw[table_name].x_offset,
			t = Draw[table_name].y + Draw[table_name].y_offset,
			w = 200,
			h = 100,
		},
		"l")
end


local function cbutton(joypad_name, offset_mult, angle)
	if Joypad[joypad_name] then -- If the button is being pressed
		circle_border(
			Draw.cbuttons.x - (Draw.cbuttons.radius) + (Draw.cbuttons.offset * offset_mult[1]),
			Draw.cbuttons.y - (Draw.cbuttons.radius) + (Draw.cbuttons.offset * offset_mult[2]),
			Draw.cbuttons.radius, Draw.buttons.thickness,
			Draw.cbuttons.color, Draw.buttons.border)
		triangle(
			Draw.cbuttons.x + (Draw.cbuttons.offset * offset_mult[1]),
			Draw.cbuttons.y + (Draw.cbuttons.offset * offset_mult[2]),
			Draw.cbuttons.triangle_size, angle,
			Draw.cbuttons.triangle_thickness, Draw.cbuttons.color, "black")
	else -- If the button isn't being pressed
		circle_border(
			Draw.cbuttons.x - (Draw.cbuttons.radius) + (Draw.cbuttons.offset * offset_mult[1]),
			Draw.cbuttons.y - (Draw.cbuttons.radius) + (Draw.cbuttons.offset * offset_mult[2]),
			Draw.cbuttons.radius, Draw.buttons.thickness,
			Draw.backgrounda, Draw.buttons.border)
		triangle(
			Draw.cbuttons.x + (Draw.cbuttons.offset * offset_mult[1]),
			Draw.cbuttons.y + (Draw.cbuttons.offset * offset_mult[2]),
			Draw.cbuttons.triangle_size, angle,
			Draw.cbuttons.triangle_thickness, Draw.backgrounda,
			Draw.buttons.border)
	end
end

---Converts the number of vis (60fps) to h:m:s:ms
---@param vi integer
---@return string
local function calc_timer(vi)
	local h = vi // 216000
	local min = (vi // 3600) - (h * 60)
	local s = (vi // 60) - (min * 60) - (h * 3600)
	local ms = Round((vi * 5 / 3) - (s * 100) - (min * 6000) - (h * 360000))
	return string.format("%02d:%02d:%02d.%02d", h, min, s, ms)
end

---The main drawing function
function Draw.main()
	-- Clear the screen
	wgui.fillrecta(Screen.start, 0, Screen.extra_width, Screen.height,
		Draw.backgrounda)

	-- Draw author
	set_text("author")
	wgui.drawtext("Author: " .. Draw.author.author,
		{
			l = Screen.init_width,
			t = Draw.author.y,
			w = Screen.extra_width,
			h = 100,
		},
		"c")

	-- Draw timer
	wgui.setfont(Draw.timer.font_size, Draw.timer.font, Draw.timer.style)
	if Draw.timer.active then
		wgui.setcolor(Draw.timer.color)
		Draw.time = VI
	else
		wgui.setcolor(Draw.timer.stopped_color)
	end
	wgui.drawtext(calc_timer(Draw.time),
		{
			l = Screen.init_width,
			t = Draw.timer.y,
			w = Screen.extra_width,
			h = 200,
		},
		"c")


	-- Draw c stick
	circle_border(Draw.cstick.x, Draw.cstick.y, Draw.cstick.size / 2,
		Draw.cstick.circle.thickness, Draw.background,
		Draw.cstick.circle.color)

	-- Draw axes
	wgui.setpen(Draw.cstick.axis.color)

	wgui.line(Draw.cstick.x, Draw.cstick.y + (Draw.cstick.size / 2),
		Draw.cstick.x + Draw.cstick.size, Draw.cstick.y + (Draw.cstick.size / 2))
	wgui.line(Draw.cstick.x + (Draw.cstick.size / 2), Draw.cstick.y,
		Draw.cstick.x + (Draw.cstick.size / 2), Draw.cstick.y + Draw.cstick.size)

	-- Draw border
	border_transparent(Draw.cstick.x, Draw.cstick.y, Draw.cstick.size,
		Draw.cstick.size,
		Draw.cstick.border.thickness,
		Draw.cstick.border.color)

	-- Draw stick
	--wgui.fillpolygona(calc_stick_points(), Draw.cstick.stick.color)
	fill_circle(
		Draw.cstick.x + Draw.cstick.size / 2 - Draw.cstick.stick.thickness / 2,
		Draw.cstick.y + Draw.cstick.size / 2 - Draw.cstick.stick.thickness / 2,
		Draw.cstick.stick.thickness,
		Draw.cstick.stick.color)

	-- Draw ball
	fill_circle(
		Draw.cstick.x + (Draw.cstick.size / 2) +
		(Joypad.X * Round(Draw.cstick.size / 2) / 128),
		Draw.cstick.y + (Draw.cstick.size / 2) -
		(Joypad.Y * Round(Draw.cstick.size / 2) / 128),
		Draw.cstick.ball.radius, Draw.cstick.ball.color)

	-- Draw c stick display
	wgui.setfont(Draw.cstick.display.font_size, Draw.cstick.display.font,
		Draw.cstick.display.style)
	wgui.setcolor(Draw.cstick.display.text_color)
	wgui.drawtext(string.format("X: %d", Joypad.X),
		{
			l = Draw.cstick.x + Draw.cstick.display.x_offset,
			t = Draw.cstick.y + Draw.cstick.display.y_offset,
			w = 200,
			h = 30,
		}
		, "l")
	wgui.drawtext(string.format("Y: %d", Joypad.Y),
		{
			l = Draw.cstick.x + Draw.cstick.display.x_offset,
			t = Draw.cstick.y + Draw.cstick.display.y_offset +
				Draw.cstick.display.distance,
			w = 200,
			h = 30,
		}, "l")


	-- Draw buttons
	button_all("a", "A", "A", 0)
	button_all("b", "B", "B", 0)
	button_all("s", "start", "S", 0)
	button_all("z", "Z", "Z", 1)
	button_all("r", "R", "R", 1)


	-- Draw c buttons
	set_text("cbuttons")
	wgui.drawtext("C",
		{
			l = Draw.cbuttons.x + Draw.cbuttons.text_offset[1],
			t = Draw.cbuttons.y + Draw.cbuttons.text_offset[2],
			w = 200,
			h = 100,
		}, "l")
	cbutton("Cup", {0, -1}, 0) -- joypad name, table with multipliers for the x and y offsets, angle
	cbutton("Cright", {1, 0}, -math.pi / 2) -- table example: {0, 0} means no offset, {1, 0} means x offset, {0, -1} means negative y offset
	cbutton("Cdown", {0, 1}, math.pi)
	cbutton("Cleft", {-1, 0}, math.pi / 2)

	-- Draw variable slots and segment counter
	set_text("slots")
	wgui.drawtext("Segment",
		{
			l = Draw.slots.x,
			t = Draw.slots.start_y,
			w = Draw.slots.x_offset,
			h = Draw.slots.y_offset,
		}
		, "l")
	wgui.drawtext(string.format("%d", Segments),
		{
			l = Draw.slots.x + Draw.slots.x_offset,
			t = Draw.slots.start_y,
			w = Screen.extra_width - (Draw.slots.x - Screen.start) -
				Draw.slots.x_offset,
			h = Draw.slots.y_offset,
		}, "l")
	for i = 1, 3, 1 do
		if Draw.slots.data[i].name ~= "" then
			wgui.drawtext(Draw.slots.data[i].name,
				{
					l = Draw.slots.x,
					t = Draw.slots.start_y + (i * Draw.slots.y_offset),
					w = Draw.slots.x_offset,
					h = Draw.slots.y_offset,
				}, "l")
			wgui.drawtext(Draw.slots.data[i].value,
				{
					l = Draw.slots.x + Draw.slots.x_offset,
					t = Draw.slots.start_y + (i * Draw.slots.y_offset),
					w = Screen.extra_width - (Draw.slots.x - Screen.start) -
						Draw.slots.x_offset,
					h = Draw.slots.y_offset,
				}, "l")
		end
	end

	-- Draw a press counter
	set_text("apress")
	wgui.drawtext("A Presses:",
		{
			l = Screen.init_width,
			t = Draw.apress.y,
			w = Screen.extra_width,
			h = 100,
		},
		"c")
	wgui.drawtext(string.format("%d", APresses),
		{
			l = Screen.init_width,
			t = Draw.apress.y + Draw.apress.offset,
			w = Screen.extra_width,
			h = 100,
		},
		"c")


	if Notes[VI] ~= nil then
		Draw.notes.state = 1
	end
	--print(Notes[VI])
	--print(VI)

	if Draw.notes.state == 1 then
		--border(Round(Draw.notes.width / 2),
		--Screen.border + Round(Draw.notes.height / 2), Draw.notes.width,
		--Draw.notes.height,
		--Draw.notes.border_thickness, Draw.notes.background,
		--Draw.notes.border_color)
	end

	--wgui.drawimage(Image.get("mario"), 0, 0, 100, 100, 0, 0, 100, 100, VI)
	--wgui.drawimage(Image.get("castle_grounds"), 0, 0, 0.1)
end
