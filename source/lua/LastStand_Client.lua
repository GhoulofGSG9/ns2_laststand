local function LoadScripts()
    Script.Load("lua/LastStand_GUIAlienSpectatorHUD.lua")
    Script.Load("lua/Hud/marine/LastStand_GUIMarineHUD.lua")
    Script.Load("lua/LastStand_GUIUpgradeChamberDisplay.lua")
end
Event.Hook("LoadComplete", LoadScripts)

AddClientUIScriptForTeam("all", "GUIRoundTime")

Script.Load("lua/LastStand_HookNetMessages_Client.lua")
Script.Load("lua/LastStand_Locale.lua")