local armory_onupdate = Armory.OnUpdate
function Armory:OnUpdate(deltaTime)

    armory_onupdate(self, deltaTime)

    self.deployed = true 

end

function Armory:GetRequiresPower()
    return false
end

function Armory:GetIsPoweredOverride()
    return true
end

function Armory:GetUseAllowedBeforeGameStart()
    return true
end

function Armory:OnUpdateAnimationInput(modelMixin)

    PROFILE("Armory:OnUpdateAnimationInput")    
    modelMixin:SetAnimationInput("powered", true)
    
end

function Armory:GetItemList(forPlayer)
    
    local itemList = {   
        kTechId.LayMines,
        kTechId.Shotgun,
        kTechId.ClusterGrenade,
        kTechId.GasGrenade,
        kTechId.PulseGrenade,
        kTechId.GrenadeLauncher,
        kTechId.Flamethrower,
    }

    return itemList
    
end