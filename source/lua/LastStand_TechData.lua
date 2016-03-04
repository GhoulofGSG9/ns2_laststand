
local kLastStand_TechData =
{        
    -- LastStand_ - equipment pile spawnables
    { [kTechDataId] = kTechId.DropShotgun,           [kTechDataMapName] = Shotgun.kMapName,               [kTechDataDisplayName] = "SHOTGUN",              [kTechDataModel] = Shotgun.kModelName },
    { [kTechDataId] = kTechId.DropMines,             [kTechDataMapName] = LayMines.kMapName,              [kTechDataDisplayName] = "MINE",                 [kTechDataModel] = Mine.kModelName },
    { [kTechDataId] = kTechId.DropGrenadeLauncher,   [kTechDataMapName] = GrenadeLauncher.kMapName,       [kTechDataDisplayName] = "GRENADE_LAUNCHER",     [kTechDataModel] = GrenadeLauncher.kModelName },
    { [kTechDataId] = kTechId.DropFlamethrower,      [kTechDataMapName] = Flamethrower.kMapName,          [kTechDataDisplayName] = "FLAMETHROWER",         [kTechDataModel] = Flamethrower.kModelName },
    { [kTechDataId] = kTechId.DropJetpack,           [kTechDataMapName] = Jetpack.kMapName,               [kTechDataDisplayName] = "JETPACK",              [kTechDataModel] = Jetpack.kModelName },
    { [kTechDataId] = kTechId.DropExosuit,           [kTechDataMapName] = Exosuit.kMapName,               [kTechDataDisplayName] = "EXOSUIT",              [kTechDataModel] = Exosuit.kModelName },
    { [kTechDataId] = kTechId.DropSentry,            [kTechDataMapName] = LastStand_BuildSentry.kMapName, [kTechDataDisplayName] = "SENTRY",               [kTechDataModel] = Sentry.kModelName },

    -- New stuff for LastStand_
    { [kTechDataId] = kTechId.DropCatPack,           [kTechDataMapName] = CatPack.kMapName,          [kTechDataDisplayName] = "CAT_PACK",             [kTechDataModel] = CatPack.kModelName },
    { [kTechDataId] = kTechId.BuildSentry,           [kTechDataMapName] = LastStand_BuildSentry.kMapName,    [kTechDataDisplayName] = "SENTRY" },

}
    
local kLastStand_TechIdToMaterialOffset = {}
kLastStand_TechIdToMaterialOffset[kTechId.DropCatPack] = 164
kLastStand_TechIdToMaterialOffset[kTechId.BuildSentry] = 5
kLastStand_TechIdToMaterialOffset[kTechId.DropSentry] = 5
kLastStand_TechIdToMaterialOffset[kTechId.Rifle] = 73
kLastStand_TechIdToMaterialOffset[kTechId.Pistol] = 104
kLastStand_TechIdToMaterialOffset[kTechId.GasGrenade] = 161
kLastStand_TechIdToMaterialOffset[kTechId.ClusterGrenade] = 161
kLastStand_TechIdToMaterialOffset[kTechId.PulseGrenade] = 161

local getmaterialxyoffset = GetMaterialXYOffset
function GetMaterialXYOffset(techId)

    local index
    index = kLastStand_TechIdToMaterialOffset[techId]
    
    if not index then
        return getmaterialxyoffset(techId)
    end
    
    local columns = 12
    index = kLastStand_TechIdToMaterialOffset[techId]
    
    if index == nil then
        Print("Warning: %s did not define kTechIdToMaterialOffset ", EnumToString(kTechId, techId) )
    end

    if(index ~= nil) then
    
        local x = index % columns
        local y = math.floor(index / columns)
        return x, y
        
    end
    
    return nil, nil
    
end

local buildTechData = BuildTechData
function BuildTechData()

    local defaultTechData = buildTechData()
    local moddedTechData = {}
    local usedTechIds = {}
    
    for i = 1, #kLastStand_TechData do
        local techEntry = kLastStand_TechData[i]
        table.insert(moddedTechData, techEntry)
        table.insert(usedTechIds, techEntry[kTechDataId])
    end
    
    for i = 1, #defaultTechData do
        local techEntry = defaultTechData[i]
        if not table.contains(usedTechIds, techEntry[kTechDataId]) then
            table.insert(moddedTechData, techEntry)
        end
    end
    
    return moddedTechData

end