function PickupableMixin:__initmixin()
	if not self.GetCheckForRecipient or self:GetCheckForRecipient() then
		self:AddTimedCallback(PickupableMixin._CheckForPickup, 0.1)
	end    
end