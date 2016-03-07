local alienspectator_oninintialized = AlienSpectator.OnInitialized
function AlienSpectator:OnInitialized()

    alienspectator_oninintialized(self)

    self:SetIsRespawning(true)  

end

function AlienSpectator:SpawnPlayer()

    local team = self:GetTeam()
    local spawn = team:GetSpawn()

    local extents = LookupTechData(kTechId.Skulk, kTechDataMaxExtents, nil)
    local capsuleHeight, capsuleRadius = GetTraceCapsuleFromExtents(extents)

    local spawnOrigin = GetRandomSpawnForCapsule(capsuleHeight, capsuleRadius, spawn:GetOrigin(), 0.5, 6, EntityFilterAll())
    local spawnAngles = spawn:GetAngles()

    local spawnClass = LookupTechData(kTechId.Skulk, kTechDataMapName)
    local _, player = team:ReplaceRespawnPlayer(self, spawnOrigin, spawnAngles, spawnClass, false)
    
    player:SetHUDSlotActive(1)
    player:UpdateArmorAmount()
    player:SetCameraDistance(0)
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

Class_Reload("AlienSpectator", networkVars)