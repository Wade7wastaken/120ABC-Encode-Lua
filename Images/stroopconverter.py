from bs4 import BeautifulSoup as bs
import luadata
from PIL import Image


def dumpobjdata():
    with open("new.xml", "r") as f:
        file = f.read()

    print(file)

    soup = bs(file, "xml")

    objects = soup.find_all("Object")

    output = []

    for o in objects:
        tbl = {}
        tbl["address"] = int(o.get("behaviorScriptAddress"), 0)
        if tbl["address"] == None:
            continue
        tbl["name"] = o.get("name")
        if tbl["name"] == None:
            tbl["name"] = "Unknown Object"
        image = o.find("MapImage")
        if image is None:
            image = o.find("Image")
        if image is None:
            image = "Default.png"
        print(image)
        tbl["image"] = image.get("path")
        if tbl["image"] == None:
            tbl["image"] = "Default.png"
        output.append(tbl)
    return luadata.serialize(output)


def processMapImages():
    with open("MapAssociations.xml", "r") as f:
        xml = f.read()

    soup = bs(xml, "xml")
    maps = soup.find_all("Map")

    for m in maps:
        fname = m.find("Image").get("path")
        tag = m.find("Coordinates")
        coords = [int(tag.get("x1")), int(tag.get("z1")),
                  int(tag.get("x2")), int(tag.get("z2"))]

        main = Image.new("RGBA", size=(16384, 16384))
        # Main output image (transparent blank)
        src = Image.open("STROOP Maps\\" + fname)
        # Origional image (wrong scaling and positioning)
        box = (coords[0] + 8191, coords[1] + 8191,
               coords[2] + 8191, coords[3] + 8191)
        # Coords in stroop(added 8191 to all)
        resize = (box[2] - box[0], box[3] - box[1])
        # Size to resize src to so it matches
        src = src.resize(resize)
        main.paste(src, box)
        final = (1500, 1500)
        main = main.resize(final)
        main.save("Lua Maps\\" + fname)
        print("Done with " + fname)


def convertMapImages():
    with open("Stroop Source/MapAssociations.xml", "rt", encoding="utf_8_sig") as f:
        xml = f.read()

    soup = bs(xml, "xml")
    maps = soup.find_all("Map")

    for m in maps:
        fname = m.find("Image").get("path")
        tag = m.find("Coordinates")
        coords = [int(tag.get("x1")), int(tag.get("z1")),
                  int(tag.get("x2")), int(tag.get("z2"))]

        # create main image
        main = Image.new("RGBA", size=(16384, 16384))

        # open STROOP image
        src = Image.open("Stroop Source/Maps/" + fname)

        box = (coords[0] + 8191, coords[1] + 8191,
               coords[2] + 8191, coords[3] + 8191)
        resize = (box[2] - box[0], box[3] - box[1])

        # resize STROOP image
        src = src.resize(resize)

        main.paste(src, box)
        final = (1500, 1500)
        main = main.resize(final)
        main.save("Maps/" + fname)
        print("Done with " + fname)

def convertObjectImages():
	with open("Stroop Source/ObjectAssociations.xml", "rt", encoding="utf_8_sig") as f:
		xml = f.read()
	
	bhvrs = {}

	soup = bs(xml, "xml")
	objects = soup.find_all("Object")

	for o in objects:
		fname = o.find("Image").get("path")
		bhvrs[int(o.get("behaviorScriptAddress"), 0)] = fname
		im = Image.open("Stroop Source/Objects/" + fname)
		im.save("Objects/" + fname)
		print("Dont with " + fname)
	
	im = Image.open("Stroop Source/Objects/Mario Top.png")
	im.save("Objects/Mario Top.png")
	
	with open("ObjectAssociations.lua", "wt") as f:
		f.write("ObjectAssociations = ")
		f.write(luadata.serialize(bhvrs))

if __name__ == "__main__":
    convertObjectImages()
