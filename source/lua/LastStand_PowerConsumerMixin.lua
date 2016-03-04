function PowerConsumerMixin:GetIsPowered() 
    local poweredOverride = self.GetIsPoweredOverride and self:GetIsPoweredOverride() or false
    return self.powered or self.powerSurge or poweredOverride == true
end