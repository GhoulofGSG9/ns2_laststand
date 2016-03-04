function MarineTeam:OnResetComplete()
end

function MarineTeam:GetSpawnPosition()
    return gMarineSpawn:GetOrigin()
end

function MarineTeam:Update(timePassed)

    PlayingTeam.Update(self, timePassed)

    --Update distress beacon mask
    self:UpdateGameMasks(timePassed)

    for index, player in ipairs(GetEntitiesForTeam("Player", self:GetTeamNumber())) do
	    player:UpdateArmorAmount(3)
    end
end