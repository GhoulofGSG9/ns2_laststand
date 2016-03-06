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

function MapCycle_GetMapInCycle(mapname)
	local cycle = MapCycle_GetMapCycle()

	for m = 1, #cycle.maps do

		local map = cycle.maps[m]
		if GetMapName(map) == mapName then
			return map, m
		end

	end
end

function MapCycle_AddMaps(maps)
	local cycle = MapCycle_GetMapCycle()

	for _, entry in ipairs(maps) do
		local mapentry, index = MapCycle_GetMapInCycle(entry.map)
		if not mapentry then
			table.insert(cycle.maps, entry)
		else
			cycle.maps[index] = entry
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