local oldUpdateTeam = GUIScoreboard.UpdateTeam
function GUIScoreboard:UpdateTeam(updateTeam)
	oldUpdateTeam(self, updateTeam)

	local teamInfoGUIItem = updateTeam["GUIs"]["TeamInfo"]
	teamInfoGUIItem:SetIsVisible(false)
end
