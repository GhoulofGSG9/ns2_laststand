function StructureAbility:GetUpgradeId()
    return kTechId.None
end

function StructureAbility:IsAllowed(player)

    local upgradeId = self:GetUpgradeId()
	return upgradeId == kTechId.None or player:GetHasUpgrade(upgradeId)	
end

function BabblerEggAbility:GetUpgradeId()
    return kTechId.DropBabbler
end

function HydraStructureAbility:GetUpgradeId()
    return kTechId.DropHydra
end

function WebsAbility:GetUpgradeId()
    return kTechId.DropWeb
end


