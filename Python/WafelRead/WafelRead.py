import sys
import wafel

#args are:
# 0. Path_to_exe
# 1. PID
# 2. base_address
# 3. game version
# 4. address

#returns (prints) in this format:
#Status Value Type

#Error format:
#Error Location ErrorInformation

if len(sys.argv) != 5:
	print("Error Args {} arguments supplied but {} are required".format(len(sys.argv) - 1, 4))
	sys.exit()

try:
	x = wafel.Emu.attach(int(sys.argv[1]), int(sys.argv[2]), sys.argv[3])
except Exception as err:
	print("Error Attach {} {}".format(type(err), err))
	sys.exit()

try:
	r = x.read(sys.argv[4])
except Exception as err:
	print("Error Read {} {}".format(type(err), err))
	sys.exit()

print("Ok {} {}".format(r, type(r)))