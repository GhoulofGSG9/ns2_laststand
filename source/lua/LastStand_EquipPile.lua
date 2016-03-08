--[[
    A pile of marine equipment. Randomly spawns cool stuff upon certain events.
    Server-side only, since clients should only know about
]]

Script.Load("lua/Mixins/ModelMixin.lua")

gEquipPiles = {}

class 'EquipPile' (Entity)

local networkVars = { }
AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ModelMixin, networkVars)

EquipPile.modelName = PrecacheAsset("models/last_stand/marine/marine_crate_02.model")
function EquipPile:GetModelName()
    return EquipPile.modelName
end

function EquipPile:OnInitialized()

    self:SetModel(self:GetModelName())

end

function EquipPile:OnCreate()

    table.insert( gEquipPiles, self )

    self:SetUpdates(true)

    if Server then
        table.insert( gGameEventListeners, self )
    end

    InitMixin(self, BaseModelMixin)
    InitMixin(self, ModelMixin)

    self.dropSentries = self.dropSentries or true
    self.dropCatpacks = self.dropCatpacks or true
    self.dropJetpacks = self.dropJetpacks or true

end

function EquipPile:SpewFrom(techIds, count)

    --noinspection UnusedDef
    for i = 1, count do

        local origin = GetRandomSpawnForCapsule( 0.2, 0.2, self:GetOrigin()+Vector(0,1,0), 0.5, 6, EntityFilterAll )
        if not origin then
            origin = self:GetOrigin() + Vector(1.0+math.random()*1.0, 0, 1.0+math.random()*1.0 )
        end

        local teamNumber = 1

        -- randomly choose
        local techId = techIds[ math.random( #techIds ) ]
        CreateEntityForTeam( techId, origin, teamNumber, nil )
    
    end

end

function EquipPile:SpewJetpack()
    if not self.dropJetpacks then return end

    local numPlayer = Server.GetNumPlayersTotal() / 2
    local num = math.max(math.round(numPlayer / #gEquipPiles), 1)

    for i = 1, num do
        if math.random() <= kJetpackDropChance then
            self:SpewFrom({kTechId.DropJetpack}, num)
            return true
        end
    end
end

function EquipPile:SpewSentries()
    if not self.dropSentries then return end

    local numPlayer = Server.GetNumPlayersTotal() / 2
    local num = math.max(math.round(numPlayer / #gEquipPiles), 1)

    for i = 1, num do
        if math.random() <= kSentryDropChance then
            self:SpewFrom({kTechId.DropSentry}, num)
            return true
        end
    end
end

function EquipPile:SpewCat()
    if not self.dropCatpacks then return end

    local numMarines = GetGamerules():GetNumMarinePlayers()
    local numCatpacks = #GetEntitiesWithinRangeAreVisible("CatPack", self:GetOrigin(), 6, true)
    local num = math.max(math.round(numMarines / #gEquipPiles), 1) - numCatpacks

    self:SpewFrom({kTechId.DropCatPack}, num)
end

function EquipPile:OnPreGameStart()

    if math.random() > 0.5 and self.dropJetpacks then
        self:SpewJetpack()
    else
        self:SpewSentries()
    end
end

function EquipPile:OnUpdate()
end

Shared.LinkClassToMap( "EquipPile", "ls_equip_pile", networkVars )
