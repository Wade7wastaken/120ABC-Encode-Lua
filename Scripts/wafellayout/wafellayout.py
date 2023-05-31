# IMPORTANT: luadata doesn't protect against having keywords (usually end) as table keys. (I've made a pr for this)
# So, if you use this script to regenerate output.lua, you must manually change them from 'end' to '["end"]'.

import json
import luadata
import os

versions = ["jp", "us", "sh", "eu"]

# loop over all versions
for version in versions:
    # open the json file and load the data into a python Dict
    with open("Scripts/wafellayout/data/sm64_" + version + ".json", "rt") as f:
        data = json.load(f)

    # create any missing directories and write the serialized lua data to the corresponding file
    fname = "Scripts/wafellayout/output/layout_" + version + ".lua"
    os.makedirs(os.path.dirname(fname), exist_ok=True)
    with open(fname, "wt") as f:
        f.write("WafelData = ")
        f.write(luadata.serialize(data, indent="\t"))

    print("Done with " + version)
