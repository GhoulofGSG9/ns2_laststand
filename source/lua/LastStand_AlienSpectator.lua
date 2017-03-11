function AlienSpectator:OnInitialized()
    TeamSpectator.OnInitialized(self)

    if Server then
        local gameInfo = GetGameInfoEntity()
        self.timeWaveSpawnEnd = gameInfo:GetStartTime() + (gameInfo:GetWave() + 1) * kWaveTime
        Server.SendNetworkMessage(Server.GetOwner(self), "SetTimeWaveSpawnEnds", { time = self.timeWaveSpawnEnd }, true)
    end
end

function AlienSpectator:GetIsOverhead()
	return false
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

        if not self.waitingToSpawnMessageSent then

            SendPlayersMessage({ self }, kTeamMessageTypes.SpawningWait)
            self.waitingToSpawnMessageSent = true

        end

        if not self.sentRespawnMessage then

            Server.SendNetworkMessage(Server.GetOwner(self), "SetIsRespawning", { isRespawning = true }, true)
            self.sentRespawnMessage = true

        end
        
    end
    
end

function AlienSpectator:GetIsValidTarget()
    return false
end

Class_Reload("AlienSpectator", networkVars)