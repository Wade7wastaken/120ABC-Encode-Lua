import json
import luadata

with open("wafelread/sm64_jp.json") as f:
    data = json.load(f)

with open("wafelread/output.lua", "wt") as f:
	f.write(luadata.serialize(data, indent="\t"))
