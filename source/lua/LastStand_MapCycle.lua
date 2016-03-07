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
local function CleanUp(mapName, cycle)

	local found = false
	local foundIndexes = {}

	for m = 1, #cycle.maps do

		local entry = cycle.maps[m]
		if GetMapName(entry) == mapName then
			if not found then
				found = true
			else
				table.insert(foundIndexes, 1, m)
			end
		end
	end

	for _, index in ipairs(foundIndexes) do
		table.remove(cycle.maps, index)
	end

	return cycle
end

function MapCycle_AddMaps(maps)
	local cycle = MapCycle_GetMapCycle()

	for _, entry in ipairs(maps) do
		cycle = CleanUp(entry.map, cycle)

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
		MapCycle_AddMaps(kLastStandMaps)
	end
end