local kIconColor = Color(kIconColors[kAlienTeamType])

-- first entry is tech id to use if the player has none of the upgrades in the list
local kIndexToUpgrades =
{
    { kTechId.Shell, kTechId.Carapace, kTechId.Regeneration },
    { kTechId.Spur, kTechId.Celerity, kTechId.Adrenaline },
    { kTechId.Veil, kTechId.Phantom, kTechId.Aura },
}

local function GetTechIdToUse(playerUpgrades, categoryUpgrades)

    for i = 1, #categoryUpgrades do

        if table.contains(playerUpgrades, categoryUpgrades[i]) then
            return categoryUpgrades[i], true
        end

    end

    return categoryUpgrades[1], false

end

function GUIUpgradeChamberDisplay:Update()

    local player = Client.GetLocalPlayer()
    if player then

        local upgrades = player:GetUpgrades()

        for i = 1, 3 do
            local techId, upgraded = GetTechIdToUse(upgrades, kIndexToUpgrades[i])

            for upgradeLevel = 1, 3 do

                    local color = Color(kIconColor.r, kIconColor.g, kIconColor.b, 1)

                    self.upgradeIcons[i][upgradeLevel]:SetTexturePixelCoordinates(unpack(GetTextureCoordinatesForIcon(techId)))
                    self.upgradeIcons[i][upgradeLevel]:SetColor(color)
                    self.upgradeIcons[i][upgradeLevel]:SetIsVisible(upgraded)

            end

        end

    end

end

