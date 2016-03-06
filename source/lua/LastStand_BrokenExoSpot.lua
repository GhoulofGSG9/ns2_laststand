--[[
    A pile of marine equipment. Randomly spawns cool stuff upon certain events.
    Server-side only, since clients should only know about
]]

class 'BrokenExoSpot' (Entity)

local kLayouts = { "MinigunMinigun", "RailgunRailgun" }

function BrokenExoSpot:OnInitialized()

end


function BrokenExoSpot:OnCreate()
    if Server then
        table.insert( gGameEventListeners, self )
    end
end


function BrokenExoSpot:OnPreGameStart()

    local coords = self:GetCoords()
    local origin = coords.origin
    origin = GetGroundAtPosition(origin, nil, PhysicsMask.AllButPCs)

    local choice = (self.exoType == nil or self.exoType == 1) and math.random(1, #kLayouts) or self.exoType - 1
    local layout = kLayouts[choice]
    local exo = CreateEntity(Exosuit.kMapName, origin, 1)
    exo:SetCoords(coords)
    exo:SetLayout(layout)

end

function BrokenExoSpot:OnUpdate()
end

Shared.LinkClassToMap( "BrokenExoSpot", "ls_exo", networkVars )

