local alienspectator_oninintialized = AlienSpectator.OnInitialized
function AlienSpectator:OnInitialized()

    alienspectator_oninintialized(self)

    self:SetIsRespawning(true)  

end

function AlienSpectator:GetIsOverhead()
	return false
end

function AlienSpectator:SpawnPlayer()

    local team = self:GetTeam()
    local spawnOrigin = GetGroundAtPosition(team:GetSpawnPosition(), nil, PhysicsMask.AllButPCs)
    local spawnAngles = team:GetSpawnAngles()

    local spawnClass = LookupTechData(kTechId.Skulk, kTechDataMapName)
    local _, player = team:ReplaceRespawnPlayer(self, spawnOrigin, spawnAngles, spawnClass, false)
    
    player:SetHUDSlotActive(1)
    player:UpdateArmorAmount()
    player:SetCameraDistance(0)
    --It is important that the player was spawned at the spot we specified.
    assert(player:GetOrigin() == spawnOrigin)   
    
end

function AlienSpectator:OnProcessMove(input)

    TeamSpectator.OnProcessMove(self, input)
    
    if Server then

        local gameState = GetGameInfoEntity():GetState()
        if gameState == kGameState.Started then
            self:SpawnPlayer()
        end
        
        if not self.waitingToSpawnMessageSent then

            SendPlayersMessage({ self }, kTeamMessageTypes.SpawningWait)
            self.waitingToSpawnMessageSent = true

        end
        
    end
    
end

function AlienSpectator:GetIsValidTarget()
    return false
end

Class_Reload("AlienSpectator", networkVars)