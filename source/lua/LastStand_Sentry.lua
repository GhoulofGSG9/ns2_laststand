local sentry_onpudate = Sentry.OnUpdate
function Sentry:OnUpdate(deltaTime)

    self.attachedToBattery = true
    self.lastBatteryCheckTime = Shared.GetTime()
    
    sentry_onpudate(self, deltaTime)

end

function Sentry:OnUpdateAnimationInput(modelMixin)

    PROFILE("Sentry:OnUpdateAnimationInput")    
    modelMixin:SetAnimationInput("attack", self.attacking)
    modelMixin:SetAnimationInput("powered", true)
    
end