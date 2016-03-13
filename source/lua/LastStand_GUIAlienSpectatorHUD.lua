local originalHUDUpdate
originalHUDUpdate = Class_ReplaceMethod( "GUIAlienSpectatorHUD", "Update", function(self)
    originalHUDUpdate(self, delatime)
    local waitingForTeamBalance = PlayerUI_GetIsWaitingForTeamBalance()

    local isVisible = not waitingForTeamBalance and GetPlayerIsSpawning()
    
    self.eggIcon:SetIsVisible(false)
    
    if isVisible then
		
		local gamestate = GetGameInfoEntity():GetState()
		if gamestate == kGameState.NotStarted then
			self.spawnText:SetText(Locale.ResolveString("WAITING_FOR_ONE_MARINE"))
		elseif gamestate == kGameState.PreGame then
			self.spawnText:SetText(Locale.ResolveString("WAITING_FOR_PREP_MARINES"))
        else
            self.spawnText:SetText(Locale.ResolveString("WAITING_TO_SPAWN"))
        end
        
    end
end)
