Screen = {
	init_width = wgui.info().width,
	init_height = wgui.info().height,
}

function Screen.init()
	Screen.width = 4 / 3 * Screen.init_width -- chose this factor because it gets 1440x1080 to 1920x1080

	if Screen.width ~= math.floor(Screen.width) then
		
		print("Current resolution cannot scale to 16:9.")
		print("Using " .. round(Screen.width) .. " instead of " .. Screen.width)
		Screen.width = round(Screen.width)
	end

	Screen.height = Screen.init_height - 24 -- This number will vary between computers, it is the size of the bottom toolbar of the mupen window, if you can't figure out what this number is for your system, ask me for help
	Screen.extra_width = Screen.width - Screen.init_width
	Screen.start = Screen.init_width
	Screen.middle = Screen.init_width + (Screen.extra_width / 2)
end

function Screen.expand()
	wgui.resize(Screen.width, Screen.init_height)
end

function Screen.contract()
	wgui.resize(Screen.init_width, Screen.init_height)
end