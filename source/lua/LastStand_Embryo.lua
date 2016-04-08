-- Instant evolve
local oldSetGestationData = Embryo.SetGestationData
function Embryo:SetGestationData(techIds, previousTechId, healthScalar, armorScalar)
	oldSetGestationData(self, techIds, previousTechId, healthScalar, armorScalar)

	self.gestationTime = 0
end

