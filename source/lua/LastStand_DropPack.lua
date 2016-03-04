function DropPack:OnInitialized()

    ScriptActor.OnInitialized(self)

	self.pickupRange = 1
	self:SetAngles(Angles(0, math.random() * math.pi * 2, 0))
	
	self:OnUpdate(0)

end