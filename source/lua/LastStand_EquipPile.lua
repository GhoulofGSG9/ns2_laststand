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

function EquipPile:GetDropTechIds()
    return
    {
        kTechId.DropJetpack,
        kTechId.DropJetpack,
        kTechId.DropSentry,
    }
end

function EquipPile:Spew()

    if Server then

        local numPlayer = Server.GetNumPlayersTotal()
        local num = math.max(math.round(numPlayer / Shared.GetEntitiesWithClassname("EquipPile"):GetSize()), 1)
        self:SpewFrom( self:GetDropTechIds(), num)

    end

end

function EquipPile:SpewCat()
    local numMarines = GetGamerules():GetNumMarinePlayers()
    self:SpewFrom({kTechId.DropCatPack}, numMarines)
end

function EquipPile:OnPreGameStart()
    self:Spew()
end

function EquipPile:OnUpdate()
end

Shared.LinkClassToMap( "EquipPile", "ls_equip_pile", networkVars )
