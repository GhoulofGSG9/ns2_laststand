function Pheromone:Initialize(techId)

    self.type = techId
    
    local lifetime = 40
    if techId == kTechId.ExpandingMarker then
        lifetime = kExpandingLifetime
    elseif techId == kTechId.ThreatMarker then
        lifetime = 15
    elseif techId == NeedHealingMarker then
        lifetime = kHurtLifetime
    end
    
    self.untilTime = Shared.GetTime() + lifetime
    self.createTime = Shared.GetTime()
    
end