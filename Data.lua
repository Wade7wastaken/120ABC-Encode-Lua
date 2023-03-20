-- Can't do anything before frame 157, each frame is a table of changes
-- each change sets the variable of the corresponding slot. Setting a slot to an empty string disables it
SlotChanges[2182] = { { 1, "hspeed", "%.3f", }, { 2, "hslidespeed", "%.3f", }, { 3, "holp", "%.0f %.0f %.0f", }, }
SlotChanges[94161] = { { 1, "", }, { 2, "", }, { 3, "", }, }
SlotChanges[109621] = { { 1, "hspeed", "%.3f", }, { 2, "hslidespeed", "%.3f", }, }
SlotChanges[111994] = { { 1, "", }, { 2, "", }, }
SlotChanges[112306] = { { 1, "hspeed", "%.3f", }, { 2, "hslidespeed", "%.3f", }, }
SlotChanges[113200] = { { 1, "", }, { 2, "", }, }

RNGChanges[2182] = 48413
RNGChanges[103409] = 10

GlobalTimerChanges[2182] = 42
GlobalTimerChanges[103409] = 4

AuthorChanges[0] = "70ABC"
AuthorChanges[2182] = "Pannenkoek2012"
AuthorChanges[94161] = "Wade7"
AuthorChanges[98797] = "70ABC"
AuthorChanges[103040] = "Wade7"
AuthorChanges[103409] = "Pannenkoek2012"
AuthorChanges[108776] = "Wade7"
AuthorChanges[109309] = "70ABC"


---Loads data defined above into other tables
local function load_data()
	---Generates Indicies
	---@param in_table table
	---@param out_table table
	local function generate_indices(in_table, out_table)
		for key, _ in pairs(in_table) do
			table.insert(out_table, key)
		end
		table.sort(out_table)
	end

	generate_indices(AuthorChanges, AuthorIndices)
	generate_indices(SlotChanges, SlotIndices)
end

load_data()
