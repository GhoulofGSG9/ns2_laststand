local GetTechIdToUse = GetUpValue( GUIUpgradeChamberDisplay.Update, "GetTechIdToUse" )
local kIconColor = GetUpValue( GUIUpgradeChamberDisplay.Update, "kIconColor" )
local kIndexToUpgrades = GetUpValue( GUIUpgradeChamberDisplay.Update, "kIndexToUpgrades" )

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

