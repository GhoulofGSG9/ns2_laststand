class 'LastStand_ReadyRoomPlayer' (Player)

LastStand_ReadyRoomPlayer.kMapName = "ls_ready_room_player"

local networkVars = { }

AddMixinNetworkVars(CameraHolderMixin, networkVars)
AddMixinNetworkVars(ScoringMixin, networkVars)

function LastStand_ReadyRoomPlayer:OnCreate()

    InitMixin(self, CameraHolderMixin, { kFov = kDefaultFov })
    InitMixin(self, ScoringMixin, { kMaxScore = kMaxScore })
	
    Player.OnCreate(self)

end


function LastStand_ReadyRoomPlayer:OnInitialized()

    Player.OnInitialized(self)
   
    self:SetIsVisible(false)     
    
    if Client and Client.GetLocalPlayer() == self then
        self.joinMenu = GetGUIManager():CreateGUIScript("LastStand_GUIJoinTeam")
        self.joinMenu.player = self
    end
    
end

function LastStand_ReadyRoomPlayer:OnDestroy()

    if self.joinMenu ~= nil then
        GetGUIManager():DestroyGUIScript(self.joinMenu)
    end
    
end

function LastStand_ReadyRoomPlayer:GetPlayerStatusDesc()
    return kPlayerStatus.Void
end

function LastStand_ReadyRoomPlayer:GetVelocity()
    return Vector(0, 0, 0)
end

function LastStand_ReadyRoomPlayer:GetVelocityFromPolar()
    return Vector(0, 0, 0)
end

-- Update origin and velocity from input.
function LastStand_ReadyRoomPlayer:OnProcessMove()
    local gamerules = GetGamerules()
    
    if gamerules and gamerules.GetTeam then
    
        local marineTeam = gamerules:GetTeam(kMarineTeamType)
        local marineSpawn = marineTeam:GetSpawnPosition()

        self:SetOrigin(marineSpawn + Vector(0, -150, 0))
    end
    
end

function LastStand_ReadyRoomPlayer:UpdateViewAngles()

    local yawDegrees = 90
    local pitchDegrees = 70
    local angles = Angles((pitchDegrees / 90) * math.pi / 2, (yawDegrees / 90) * math.pi / 2, 0)
    
    -- Update to the current view angles.
    self:SetViewAngles(angles)

end

function LastStand_ReadyRoomPlayer:GetIsOverhead()
    return true
end

function LastStand_ReadyRoomPlayer:GetGravityEnabled()
    return true
end

function LastStand_ReadyRoomPlayer:SetGravityEnabled(enabled)
end

function LastStand_ReadyRoomPlayer:GetIsVisible()
	return false
end

Shared.LinkClassToMap("LastStand_ReadyRoomPlayer", LastStand_ReadyRoomPlayer.kMapName, networkVars)
