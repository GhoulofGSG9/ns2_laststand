Script.Load("lua/ServerAdmin.lua")
local function OnCommandLength(client, arg) 
    local t = tonumber(arg)
    Print("Setting the round length to %0.2fs", t)
    GetGamerules():SetRoundLength(t)
end

CreateServerAdminCommand("Console_sv_ls_length", OnCommandLength, "<number> in the console to set round length in seconds.")

local function OnCommandPreGameLength(client, arg) 
    local t = tonumber(arg)
    Print("Setting the pregame length to %0.2fs", t)
    GetGamerules():SetPreGameLength(t)
end

CreateServerAdminCommand("Console_sv_ls_pregamelength", OnCommandPreGameLength, "<number> in the console to set the pre game length in seconds.")

local function OnCommandSecsPerWave(client, arg) 
    local t = tonumber(arg)
    Print("Setting the number of seconds per wave to %0.2fs", t)
    GetGamerules():SetNumSecondsPerWave(t)
end
CreateServerAdminCommand("Console_sv_ls_secsperwave", OnCommandSecsPerWave, "<number> in the console to set number of seconds per wave in seconds.")

CreateServerAdminCommand("Console_sv_ls_spew", 
        function(client)
            if gEquipPiles then
                for _, pile in ipairs(gEquipPiles) do
                    pile:Spew()
                end
            end
        end, 
"Spawns more items")