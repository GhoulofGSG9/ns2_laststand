if Server then

	local kGamerulesLoaded
	local function OnMapPostLoad()

		-- Create the global game controller entity if needed
		if not kGamerulesLoaded then
			Print("Loading Last Stand gamerules")
			CreateEntity( "ns2_gamerules" )
		end

	end
	Event.Hook( "MapPostLoad" , OnMapPostLoad)

	local function OnMapLoadEntity( classname )
		if classname == "ns2_gamerules" then
			Print("Loading Last Stand gamerules")
			kGamerulesLoaded = true
		end
	end
	Event.Hook( "MapLoadEntity", OnMapLoadEntity)

end

ModLoader.SetupFileHook( "lua/Gamerules.lua", "lua/LastStand_Gamerules.lua", "post" )
ModLoader.SetupFileHook( "lua/NS2Gamerules.lua", "lua/LastStand_NS2Gamerules.lua", "post" )
ModLoader.SetupFileHook( "lua/TechTreeConstants.lua", "lua/LastStand_TechTreeConstants.lua", "post" )
ModLoader.SetupFileHook( "lua/NetworkMessages.lua", "lua/LastStand_NetworkMessages.lua", "post" )
ModLoader.SetupFileHook( "lua/PlayingTeam.lua", "lua/LastStand_PlayingTeam.lua", "post" )
ModLoader.SetupFileHook( "lua/Weapons/Alien/StructureAbility.lua", "lua/Weapons/Alien/LastStand_StructureAbility.lua" , "post" )
ModLoader.SetupFileHook( "lua/Player.lua", "lua/LastStand_Player.lua" , "post" )
ModLoader.SetupFileHook( "lua/Weapons/Alien/DropStructureAbility.lua", "lua/Weapons/Alien/LastStand_DropStructureAbility.lua" , "post" )
ModLoader.SetupFileHook( "lua/Armory.lua", "lua/LastStand_Armory.lua", "post" )
ModLoader.SetupFileHook( "lua/PowerConsumerMixin.lua", "lua/LastStand_PowerConsumerMixin.lua", "post" )
ModLoader.SetupFileHook( "lua/Balance.lua", "lua/LastStand_Balance.lua", "post" )


ModLoader.SetupFileHook( "lua/GUIMinimapFrame.lua", "lua/LastStand_GUIMinimapFrame.lua", "post" )
ModLoader.SetupFileHook( "lua/GUIFirstPersonSpectate.lua", "lua/LastStand_GUIFirstPersonSpectate.lua", "post" )
ModLoader.SetupFileHook( "lua/GUIScoreboard.lua", "lua/LastStand_GUIScoreboard.lua", "post" )

ModLoader.SetupFileHook( "lua/GUIInsight_TopBar.lua", "lua/LastStand_GUIInsight_TopBar.lua", "replace" )

--Block all not needed Vanilla Files here
local kBlockedFiles ={ 
    "lua/GUIWaitingForAutoTeamBalance.lua", "lua/GUIInsight_TechPoints.lua","lua/GUIInsight_Location.lua","lua/GUIInsight_Graphs.lua", "lua/GUIReadyRoomOrders.lua", "lua/GUIInsight_TopBar.lua"
}

for _,fileName in ipairs(kBlockedFiles) do
	ModLoader.SetupFileHook( fileName, "lua/LastStand_FileHooks.lua", "halt" )
end