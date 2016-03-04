local kFindWeaponRange = 2
local kIconUpdateRate = 0.5

local function SortByValue(item1, item2)

    local cost1 = HasMixin(item1, "Tech") and LookupTechData(item1:GetTechId(), kTechDataCostKey, 0) or 0
    local cost2 = HasMixin(item2, "Tech") and LookupTechData(item2:GetTechId(), kTechDataCostKey, 0) or 0

    return cost1 > cost2

end

local function FindNearbyWeapon(self, toPosition)

    local nearbyWeapons = GetEntitiesWithMixinWithinRange("Pickupable", toPosition, kFindWeaponRange)
    table.sort(nearbyWeapons, SortByValue)
    
    local closestWeapon
	local closestDistance = Math.infinity
    for _, nearbyWeapon in ipairs(nearbyWeapons) do
    
        if nearbyWeapon:isa("Weapon") and nearbyWeapon:GetIsValidRecipient(self) then
        
            local nearbyWeaponDistance = (nearbyWeapon:GetOrigin() - toPosition):GetLengthSquared()
            if nearbyWeaponDistance < closestDistance then
            
                closestWeapon = nearbyWeapon
                closestDistance = nearbyWeaponDistance
            
            end
            
        end
        
    end
    
    return closestWeapon

end

function MarineActionFinderMixin:OnProcessMove()
    
	PROFILE("MarineActionFinderMixin:OnProcessMove")

	local prediction = Shared.GetIsRunningPrediction()
	local now = Shared.GetTime()
	local lastActionTime = self.lastMarineActionFindTime or 0
	local enoughTimePassed = (now - lastActionTime) >= kIconUpdateRate
	if not prediction and enoughTimePassed then
	
		self.lastMarineActionFindTime = now
		
		local success = false
		
		if self:GetIsAlive() then
		
			local foundNearbyWeapon = FindNearbyWeapon(self, self:GetOrigin())
			if foundNearbyWeapon then
			
				self.actionIconGUI:ShowIcon(BindingsUI_GetInputValue("Drop"), foundNearbyWeapon, nil)
				success = true
				
			else
			
				local ent = self:PerformUseTrace()
				if ent then
				
					if GetPlayerCanUseEntity(self, ent) and not self:GetIsUsing() then
					
						self.actionIconGUI:ShowIcon(BindingsUI_GetInputValue("Use"), nil, "Use", nil)
						success = true
						
					end
					
				end
				
			end
			
		end
		
		if not success then
			self.actionIconGUI:Hide()
		end
		
	end
	
end