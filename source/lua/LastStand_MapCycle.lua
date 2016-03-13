local modId = "25e20012"
local kLastStandMaps = {
	{
		map = "ns2_ls_pad",
		mods = {
			modId
		}
	},
	{
		map = "ns2_ls_hangar",
		mods = {
			"25E64DC3",
			modId
		}
	},
	{
		map = "ns2_ls_frost",
		mods = {
			"261A4B61",
			modId
		}
	},
	{
		map = "ns2_ls_hellevator",
		mods = {
			"85E539B",
			modId
		}
	},
	{
		map = "ns2_ls_descent",
		mods = {
			"25E6405A",
			modId
		}
	},
	{
		map = "ns2_ls_rockdown",
		mods = {
			"25E6537D",
			modId
		}
	},
	{
		map = "ns2_ls_storm",
		mods = {
			"261A4B61",
			modId
		}
	},
	{
		map = "ns2_ls_eclipse",
		mods = {
			"261A4B61",
			modId
		}
	},
	{
		map = "ns2_ls_traction",
		mods = {
			"2655cd48",
			modId
		}
	},
	{
		map = "ns2_ls_troopers",
		mods = {
			"261A4B61",
			modId
		}
	}
}

local kLastStandDefaultConfig = {
	checkmapcycle = true,
}

local configFileName = "LastStandConfig.json"
local config = LoadConfigFile(configFileName, kLastStandDefaultConfig, true)

local function GetMapName(map)

	if type(map) == "table" and map.map ~= nil then
		return map.map
	end
	return map

end

local function GetMapInCycle(mapname, cycle)
	for m = 1, #cycle.maps do
		local map = cycle.maps[m]
		if GetMapName(map) == mapname then
			return map, m
		end

	end
end

--We messed up, so we have to clean up our mess
local function RemoveDuplicatedMaps()
	local cycle = MapCycle_GetMapCycle()

	local changed = false
	local found = {}

	local newCycle = cycle
	newCycle.maps = {}

	 for _, entry in ipairs(cycle.maps) do

		if not found[GetMapName(entry)] then
			found[GetMapName(entry)] = true
			table.insert(newCycle.maps, entry)
		else
			changed = true
		end
	end

	if changed then
		MapCycle_SetMapCycle(cycle)
	end
end

function MapCycle_AddMaps(maps)
	local cycle = MapCycle_GetMapCycle()

	for _, entry in ipairs(maps) do
		local mapentry, index = GetMapInCycle(entry.map, cycle)
		if not mapentry then
			table.insert(cycle.maps, entry)
		else
			mapentry.mods = entry.mods
			cycle.maps[index] = mapentry
		end
	end

	MapCycle_SetMapCycle(cycle)
end

--We keep the server's map cycle up to date if the checkmapcycle option is set true
do
	if config.checkmapcycle then
		Shared.Message("Updating Last Stand Maps ...")
		RemoveDuplicatedMaps()
		MapCycle_AddMaps(kLastStandMaps)
	end
end