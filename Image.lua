Image = {}

function Image.get(fname)
	if Image[fname] == nil then
		Image[fname] = wgui.loadimage(Path .. fname)
	end
	return Image[fname]
end

function Image.getinfo(fname)
	if Image[fname] == nil then
		Image[fname] = wgui.loadimage(Path .. fname)
	end
	return wgui.getimageinfo(Image[fname])
end
