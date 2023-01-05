Slots = {
	{
		var = "",
		occupied = false
	},
	{
		var = "",
		occupied = false
	},
	{
		var = "",
		occupied = false
	}
}

function Slots.add(variable)
	local open_slot = Slots.find_open_slot()
	Slots[open_slot].occupied = true
	Slots[open_slot].var = variable
end

function Slots.remove(slot)
	Slots.clear(slot)
	for i = slot + 1, 3, 1 do
		Slots.copy(i, i - 1)
	end
end

function Slots.clearAll()
	Slots.clear(3)
	Slots.clear(2)
	Slots.clear(1)
end

function Slots.clear(slot)
	Slots[slot].var = ""
	Slots[slot].occupied = false
end

function Slots.copy(source, destination)
	Slots[destination].var = Slots[source].var
	Slots[destination].occupied = Slots[source].occupied
end

function Slots.find_open_slot()
	if not Slots[1].occupied then
		return 1
	end
	if not Slots[2].occupied then
		return 2
	end
	if not Slots[3].occupied then
		return 3
	end
	print("Error. No unoccupied slots")
	return nil
end
