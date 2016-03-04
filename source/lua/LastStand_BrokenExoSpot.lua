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

    -- randomly choose
    local randomLayout = kLayouts[(math.random(1, #kLayouts))]
    local exo = CreateEntity(Exosuit.kMapName, origin, 1)
    exo:SetCoords(coords)
    exo:SetLayout(randomLayout)

end

function BrokenExoSpot:OnUpdate()
end

Shared.LinkClassToMap( "BrokenExoSpot", "ls_exo", networkVars )

