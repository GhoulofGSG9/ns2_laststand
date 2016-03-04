local gTechIdToString = {}

local function createTechIdEnum(table)

    for i = 1, #table do
        gTechIdToString[table[i]] = i
    end
    
    return enum(table)

end

function StringToTechId(string)
    return gTechIdToString[string] or kTechId.None
end

local techIdStrings = {}

for i = 1, #kTechId do
    if kTechId[i] ~= "Max" then
        table.insert(techIdStrings, kTechId[i])
    end
end    

local kLastStand_TechIds =
{
    'BuildSentry',
    'DropCatPack',
    'DropSentry',
    'DropBabbler',
    'DropHydra',
    'DropWeb',
}

for i = 1, #kLastStand_TechIds do
    table.insert(techIdStrings, kLastStand_TechIds[i])
end

techIdStrings[#techIdStrings + 1] = 'Max'

kTechId = createTechIdEnum(techIdStrings)
kTechIdMax  = kTechId.Max
