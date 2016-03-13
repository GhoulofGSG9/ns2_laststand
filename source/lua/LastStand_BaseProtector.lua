Script.Load("lua/TechMixin.lua")
Script.Load("lua/Mixins/SignalListenerMixin.lua")

class 'LastStand_BaseProtector' (Trigger)

LastStand_BaseProtector.kMapName = "ls_base_protector"

local networkVars =
{
}

AddMixinNetworkVars(TechMixin, networkVars)

local teamType = enum({ "Both", "Marine", "Alien" })
local teamProtectingType = enum({ "Marine", "Alien" })


local function KillEntity(self, entity)

    if Server and HasMixin(entity, "Live") and entity:GetIsAlive() and entity:GetCanDie(true) then
    
        local direction = GetNormalizedVector(entity:GetModelOrigin() - self:GetOrigin())
        entity:Kill(self, self, self:GetOrigin(), direction)
        
    end
    
end

local function KillAllInTrigger(self)

    for _, entity in ipairs(self:GetEntitiesInTrigger()) do
        KillEntity(self, entity)
    end
    
end

function LastStand_BaseProtector:OnCreate()

    Trigger.OnCreate(self)
    
    InitMixin(self, TechMixin)
    InitMixin(self, SignalListenerMixin)
    
    self.enabled = true
    
    self:RegisterSignalListener(function() KillAllInTrigger(self) end, "kill")
    
end

local function GetDamageOverTimeIsEnabled(self)
    return self.damageOverTime ~= nil and self.damageOverTime > 0
end

local function GetTeamType(self)
    return self.teamType ~= nil and self.teamType
end

local function GetTeamProtecting(self)
    return self.teamProtecting ~= nil and self.teamProtecting
end

function LastStand_BaseProtector:OnInitialized()

    Trigger.OnInitialized(self)
    
    self:SetTriggerCollisionEnabled(true)
    
    self:SetUpdates(GetDamageOverTimeIsEnabled(self))
end

local function wouldDie(ent, damage)
	return ent:GetHealth() + ent:GetArmor() * 2 <= damage
end

local function dealDamage(ent, damage)
	if wouldDie(ent,damage) then
		ent:SetHealth(1)
		ent:SetArmor(0)
	elseif ent:isa("Exo") then
		ent:TakeDamage(damage, nil, nil, nil, nil, damage, 0, kDamageType.Normal)
	else
		ent:TakeDamage(damage, nil, nil, nil, nil, 0, damage, kDamageType.Normal)
	end
end

local function DoDamageOverTime(self, entity, damage)

    if HasMixin(entity, "Live") then
        if GetTeamType(self) == teamType.Both or self.teamType == nil then
	        dealDamage(entity, damage)
        elseif GetTeamType(self) == teamType.Marine and entity:isa("Marine") then
	        dealDamage(entity, damage)
        elseif GetTeamType(self) == teamType.Marine and entity:isa("Exo") then
	        dealDamage(entity, damage)
        elseif GetTeamType(self) == teamType.Alien and entity:isa("Alien") then
	        dealDamage(entity, damage)
        end
    end
    
end

function LastStand_BaseProtector:OnUpdate(deltaTime)

    if GetDamageOverTimeIsEnabled(self) then
        self:ForEachEntityInTrigger(function(entity) DoDamageOverTime(self, entity, self.damageOverTime * deltaTime) end)
    end
    
end

function LastStand_BaseProtector:OnTriggerEntered(enterEnt)

	if Server and HasMixin(enterEnt, "Team") then
		if self.teamType ~= teamType.Both and self.teamType ~= enterEnt:GetTeamNumber() + 1 then return end

        if self.enabled and not GetDamageOverTimeIsEnabled(self) then
            KillEntity(self, enterEnt)
        elseif GetTeamProtecting(self) == teamProtectingType.Alien and (enterEnt:isa("Marine") or enterEnt:isa("Exo")) then
	        SendPlayersMessage({enterEnt}, kTeamMessageTypes.ReturnToBase)
        elseif GetTeamProtecting(self) == teamProtectingType.Marine and enterEnt:isa("Alien") then
	        SendPlayersMessage({enterEnt}, kTeamMessageTypes.ReturnToBase)
        end
    end
    
end

Shared.LinkClassToMap("LastStand_BaseProtector", LastStand_BaseProtector.kMapName, networkVars)