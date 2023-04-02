import os
from bs4 import BeautifulSoup as bs

offsets = []

for file in os.listdir("STROOP Data/"):
    with open("STROOP Data/" + file, "r", encoding="utf_8_sig") as f:
        data = f.read()
        soup = bs(data, 'xml')
        for vardata in soup.find_all("VarData"):
            for datatag in vardata.find_all("Data"):
                if datatag["base"] == "Mario" and not "mask" in datatag.attrs:
                    print(datatag)
                    offsets.append(int(datatag["offset"], 16))
                    
offsets.sort()
print(offsets)
