function OnOpenBuyMenu() 
    local player = Client.GetLocalPlayer()
    player:Buy()
end

Client.HookNetworkMessage("OpenBuyMenu", OnOpenBuyMenu)