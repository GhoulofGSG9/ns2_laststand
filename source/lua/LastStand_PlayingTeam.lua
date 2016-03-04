function PlayingTeam:TriggerAlert()
end

function PlayingTeam:ResetTeam()

    self.conceded = false

    local players = GetEntitiesForTeam("Player", self:GetTeamNumber())
    for p = 1, #players do
    
        local player = players[p]
		self:ReplaceRespawnPlayer(player, nil, nil )
        
    end

    self.techTree:SetTechChanged()

end

--[[
 * Transform player to appropriate team respawn class and respawn them at an appropriate spot for the team.
 * Pass nil origin/angles to have spawn entity chosen.
]]
function PlayingTeam:ReplaceRespawnPlayer(player, origin, angles, mapName, preventWeapons)

    local spawnMapName = self.respawnEntity
    
    if mapName ~= nil then
        spawnMapName = mapName
    end
    
    local newPlayer = player:Replace(spawnMapName, self:GetTeamNumber(), false, origin, { preventWeapons = preventWeapons })
    
    Server.SendNetworkMessage(player, "OpenBuyMenu", { }, true)
    
    -- If we fail to find a place to respawn this player, put them in the Team's
    -- respawn queue.
    if not self:RespawnPlayer(newPlayer, origin, angles) then
    
        newPlayer = newPlayer:Replace(newPlayer:GetDeathMapName())
        self:PutPlayerInRespawnQueue(newPlayer)
        
    end
    
    newPlayer:ClearGameEffects()
    if HasMixin(newPlayer, "Upgradable") then
        newPlayer:ClearUpgrades()
    end
    
    return (newPlayer ~= nil), newPlayer
    
end

--Call with origin and angles, or pass nil to have them determined from team location and spawn points.
function PlayingTeam:RespawnPlayer(player, origin, angles)

    local success = false

    if origin ~= nil and angles ~= nil then
        success = Team.RespawnPlayer(self, player, origin, angles)

    else
    
        local spawnOrigin = self:GetSpawnPosition()

        if spawnOrigin ~= nil then
            --Compute random spawn location
            local capsuleHeight, capsuleRadius = player:GetTraceCapsule()

            local spawnPoint = player:GetIsOnPlayingTeam() and GetRandomSpawnForCapsule(capsuleHeight, capsuleRadius, spawnOrigin, 2, 7, EntityFilterAll()) or spawnOrigin
            success = Team.RespawnPlayer(self, player, spawnPoint, Angles(0, 0, 0))
            
        else

            Print("PlayingTeam:RespawnPlayer: Couldn't compute random spawn for player.\n")
            Print(Script.CallStack())
            
        end

    end
    
    Server.SendNetworkMessage(player, "OpenBuyMenu", { }, true)
    
    return success
    
end

function PlayingTeam:UpdateMinResTick()
end

function PlayingTeam:SetTeamResources()
end

function PlayingTeam:GetTeamResources()
    return 0
end

function PlayingTeam:AddTeamResources()
end

function PlayingTeam:GetTotalTeamResources()
    return 0
end

function PlayingTeam:GetNumAlivePlayers()
	local num = 0
	local function CountActivePlayers(player)
		if player:GetIsAlive() and player:GetTeam() == self then
			num = num + 1
		end
	end
	self:ForEachPlayer( CountActivePlayers )
	
	return num
end
