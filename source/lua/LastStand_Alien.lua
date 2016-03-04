function Alien:UpdateArmorAmount()

    local newMaxArmor = self:GetBaseArmor()

    if GetHasCarapaceUpgrade(self) then
        newMaxArmor = self:GetArmorFullyUpgradedAmount()
    end

    if newMaxArmor ~= self.maxArmor then

        local armorPercent = self.maxArmor > 0 and self.armor/self.maxArmor or 0
        self.maxArmor = newMaxArmor
        self:SetArmor(self.maxArmor * armorPercent)
    
    end

end

function GetShellLevel()
    return 3
end

function GetSpurLevel()
    return 3
end

function GetVeilLevel()
    return 3
end
Class_Reload( "Alien" )