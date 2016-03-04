--Adds a damaged cinematic to exos
local kDamagedCinematic = PrecacheAsset("cinematics/marine/exo/hurt_severe_ls.cinematic")
local kFlaresAttachpoint = "Exosuit_UpprTorso"
local damagedCinematic = nil
local needsDestroyed = false

local exosuit_oninit = Exosuit.OnInitialized
function Exosuit:OnInitialized()

    if exosuit_oninit then
        exosuit_oninit(self)
    end
    
    if Client then

        local coords = self:GetCoords()
        coords.origin.y = coords.origin.y - 0.5
        
        damagedCinematic = Client.CreateCinematic(RenderScene.Zone_Default)
        damagedCinematic:SetCinematic(kDamagedCinematic)
        damagedCinematic:SetRepeatStyle(Cinematic.Repeat_Endless)
        damagedCinematic:SetCoords(coords)
        --damagedCinematic:SetAttachPoint(self:GetAttachPointIndex(kFlaresAttachpoint))
        damagedCinematic:SetIsVisible(true)
        
    end
    
end

local exo_onupdaterender = Exo.OnUpdateRender
function Exo:OnUpdateRender()

    if exo_onupdaterender then
        exo_onupdaterender(self)
    end
    if Client and damagedCinematic then
        local player = Client.GetLocalPlayer()
        damagedCinematic:SetIsVisible(not player:isa("Exo"))        
    end
end

local exosuit_onkillclient = Exosuit.OnKillClient
function Exosuit:OnKillClient()

    if exosuit_onkillclient then
        exosuit_onkillclient(self)
    end

    if damagedCinematic then
        Client.DestroyCinematic(damagedCinematic)   
        damagedCinematic = nil
    end
    
end

function Exosuit:GetIsValidRecipient(recipient)
    return not recipient:isa("Exo")
end

function Exosuit:GetUseAllowedBeforeGameStart()
    return true
end