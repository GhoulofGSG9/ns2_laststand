------------------------------------------
--  Last Stand - amount of seconds left in round
------------------------------------------
class "GUIRoundTime" (GUIScript)

local kWidgetHeight = 50
local timeLeft = 0
local defaultWidth = 100
local texture_alien = PrecacheAsset("ui/game_timer_alien.dds")
local texture_marine = PrecacheAsset("ui/game_timer_marine.dds")

function GUIRoundTime:Initialize()

    GUIScript.Initialize(self)
    
    -- Compute size/pos
    
    self.widget = GUIManager:CreateGraphicItem()
    self.widget:SetColor( Color(1.0, 1.0, 1.0, 0.5) )
    self.widget:SetAnchor(GUIItem.Center, GUIItem.Top)
    self.widget:SetPosition(Vector(-defaultWidth/2, 0, 0))
    self.widget:SetSize( Vector(defaultWidth, kWidgetHeight, 0) )
    self.widget:SetIsVisible(true)

    self.timeText = GUI.CreateItem()
    self.timeText:SetOptionFlag(GUIItem.ManageRender)
    self.timeText:SetInheritsParentAlpha( false )
    self.timeText:SetAnchor(GUIItem.Center, GUIItem.Center)
    self.timeText:SetPosition(Vector(0,0,0))
    self.timeText:SetTextAlignmentX(GUIItem.Align_Center)
    self.timeText:SetTextAlignmentY(GUIItem.Align_Center)
    self.timeText:SetFontName(Fonts.kAgencyFB_Small)
    self.timeText:SetText("00:00")

    self.widget:AddChild(self.timeText)
    
    local player = Client.GetLocalPlayer()
    self.teamNumber = player:GetTeamNumber()
    
    if player:GetTeamNumber() == kTeam2Index then
        self.widget:SetTexture(texture_alien)
    else
        self.widget:SetTexture(texture_marine)
    end
    
end

function GUIRoundTime:Uninitialize()

    if self.widget then
        GUI.DestroyItem( self.widget )
        self.widget = nil
    end

end

function GUIRoundTime:SetWidgetSize(wt,ht)
    if ht == nil then ht = kWidgetHeight end
    self.widget:SetSize( Vector(wt, ht, 0) )
    self.widget:SetPosition(Vector(-wt/2, 0, 0))
end

function GUIRoundTime:Update(dt)

    GUIScript.Update(self, dt)
	
	local gameState = GetGameInfoEntity():GetState()
	timeLeft = GetGameInfoEntity():GetGameTimeLeft()
    
    local player = Client.GetLocalPlayer()
    
    if self.teamNumber ~= player:GetTeamNumber() then
        if player:GetTeamNumber() == kTeam2Index then
            self.widget:SetTexture(texture_alien)
        else
            self.widget:SetTexture(texture_marine)
        end
    
        self.teamNumber = player:GetTeamNumber()
    end
    
	if gameState == kGameState.PreGame then
		timeLeft = math.max( 0, timeLeft - dt)
        if timeLeft < 10 then
            self.timeText:SetText(string.format("%s %0.2f", Locale.ResolveString("MARINE_PREP_TIME_LEFT"), timeLeft))
        else
            self.timeText:SetText(string.format("%s %d", Locale.ResolveString("MARINE_PREP_TIME_LEFT"), timeLeft))
        end
        self.timeText:SetColor( Color(1,1,0,1) )
        self:SetWidgetSize(250, nil)

    elseif gameState == kGameState.Started then

        local player = Client.GetLocalPlayer()
		
        if player then
			timeLeft = math.max( 0, timeLeft - dt)
            local numMarines = GetGameInfoEntity():GetNumMarinesLeft()
            local wave = math.min(GetGameInfoEntity():GetWave(), 12)
            local text = Pluralize(numMarines, "Marine")
            
            --color
            if timeLeft < 30.0 then
                self.timeText:SetColor( Color(1,0,0,1) )
                self.timeText:SetText( string.format("%s - Wave %d - Marine Rescue in %0.2f", text, wave, timeLeft ) )
            else
                self.timeText:SetColor( kChatTextColor[player:GetTeamType()] )
                self.timeText:SetText( string.format("%s - Wave %d - Marine Rescue in %d", text, wave, timeLeft ) )
            end

            self:SetWidgetSize(self.timeText:GetSize().x + 20, nil)

        end

    elseif gameState == kGameState.Team1Won or gameState == kGameState.Team2Won then

        self.timeText:SetColor( Color(1,0,0,1) )
        self.timeText:SetText( string.format("GG - %d", timeLeft))

    end
    
end
