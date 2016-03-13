gAlienSpawns = {}
class 'AlienSpawn' (ScriptActor)

local networkVars = { }
AddMixinNetworkVars(InfestationMixin, networkVars)

function AlienSpawn:OnInitialized()
    ScriptActor.OnInitialized(self)

    if self.spawnInfestation ~= false then
        InitMixin(self, InfestationMixin)
        self:SetInfestationFullyGrown()
    end

    table.insert(gAlienSpawns, self)
    
    if Server then
        table.insert( gGameEventListeners, self )
    end
    
end

function AlienSpawn:OnPreGameStart()
end

function AlienSpawn:GetIsLiveEntitiy()
    return false
end

function AlienSpawn:GetInfestationRadius()
    return kHiveInfestationRadius
end

function AlienSpawn:GetInfestationMaxRadius()
    return kHiveInfestationRadius
end

function AlienSpawn:GetInfestationBlobMultiplier()
    return 8
end

gMarineSpawn = nil
class 'MarineSpawn' (ScriptActor)
function MarineSpawn:OnCreate()
    ScriptActor.OnCreate(self)
    gMarineSpawn = self
end

function MarineSpawn:OnInitialized()
    ScriptActor.OnInitialized(self)
end

class 'LSArmory' (Entity)
function LSArmory:OnCreate()
    if Server then
        table.insert( gGameEventListeners, self )
    end
end
function LSArmory:OnPreGameStart()
    if Server then
        local origin = self:GetOrigin()
        origin = GetGroundAtPosition(origin, nil, PhysicsMask.AllButPCs)
        local scriptActor = CreateEntity(Armory.kMapName, origin, 1)
        scriptActor:SetConstructionComplete()
    end
end

class 'LSAlienWaypoint' (Entity)
function LSAlienWaypoint:OnCreate()
    if Server then
        table.insert( gGameEventListeners, self )
    end
end

function LSAlienWaypoint:OnGameStart()
    if Server then
        CreatePheromone(kTechId.ThreatMarker, self:GetOrigin(), 2)
    end
end

Shared.LinkClassToMap("AlienSpawn", "ls_alien_spawn", networkVars)
Shared.LinkClassToMap("MarineSpawn", "ls_marine_spawn", { })
Shared.LinkClassToMap("LSArmory", "ls_armory", { })
Shared.LinkClassToMap("LSAlienWaypoint", "ls_alien_waypoint", { })