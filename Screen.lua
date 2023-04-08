Screen = {
	init_width = wgui.info().width,
	init_height = wgui.info().height,
}

---Initializes the Screen module
local function init()
	Screen.width = 4 / 3 *
		Screen.init_width -- chose this factor because it gets 1440x1080 to 1920x1080

	if Screen.width ~= math.floor(Screen.width) then
		print("Current resolution cannot scale to 16:9.")
		print("Using " .. Round(Screen.width) .. " instead of " .. Screen.width)
		Screen.width = Round(Screen.width)
	end

	-- This number will vary between computers, it is the size of the bottom toolbar of the mupen window, if you can't figure out what this number is for your system, ask me for help
	Screen.height = Screen.init_height - 24
	Screen.extra_width = Screen.width - Screen.init_width
	Screen.start = Screen.init_width
	Screen.middle = Screen.init_width + (Screen.extra_width / 2)
	Screen.border = Round(Screen.height / 30)

	if DRAWING then
		Screen.expand()
	end
end

---Expands the screen
function Screen.expand()
	wgui.resize(Screen.width, Screen.init_height)
end

---Contracts the screen back to the original dimensions
function Screen.contract()
	wgui.resize(Screen.init_width, Screen.init_height)
end

init()
