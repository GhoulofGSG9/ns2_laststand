class 'LastStand_GUIJoinTeam' (GUIScript)

Script.Load('lua/SimpleGUI.lua')

local kPromptGap = 34
local kChooseSideGap = 80
local kLogoWidth = 690
local kLogoHeight = 339

local kChooseTeamAtlas = SGMakeAtlas("ui/ChooseTeam.dds", {
    prompt = { 1, 1, 128, 599 },
    spectate = { 1, 600, 600, 128 },
    marines = { 130, 1, 395, 587 },
    aliens = { 526, 1, 395, 587 }
})

local kLogoAtlas = SGMakeAtlas("ui/menu/ls_logo.dds", {
    logo = { 1, 1, 690, 337 },
})

function LastStand_GUIJoinTeam:_AddJoinButton(background, xOffset, teamIndex, region, borderSize, selectedColor, slideDir)
    
    local notSelectedColor = Color(0, 0, 0, 0.5)
    local width, height = SGGetRegionSize(region)
    
    local buttonFrame = SGAddGraphic(self.menu, background)
    buttonFrame:SetSize(Vector(width + 2*borderSize, height + 2*borderSize, 0))
    buttonFrame:SetAnchor(GUIItem.Left, GUIItem.Top)    
    buttonFrame:SetPosition(Vector(xOffset + slideDir*400, 0, 0))
    buttonFrame:SetColor(Color(0, 0, 0, 0))
    
    local button = SGAddGraphic(self.menu, buttonFrame, region)    
    button:SetAnchor(GUIItem.Left, GUIItem.Top)    
    button:SetPosition(Vector(borderSize, borderSize, 0))
    button:SetInheritsParentAlpha(true)

    local function enableButton()
        
        buttonFrame.isMouseOver = false
        buttonFrame.OnMouseEnter = function()
            if not MainMenu_GetIsOpened() then
                SGAddPropertyAnim(self.menu, buttonFrame, kSGScale, Vector(1.08, 1.08, 1)) 
                SGAddPropertyAnim(self.menu, buttonFrame, kSGColor, selectedColor) 
                Shared.PlaySound(nil, "sound/NS2.fev/alien/common/alien_menu/hover")
            end
        end
        
        buttonFrame.OnMouseExit = function()
            SGAddPropertyAnim(self.menu, buttonFrame, kSGScale, Vector(1, 1, 1)) 
            SGAddPropertyAnim(self.menu, buttonFrame, kSGColor, notSelectedColor)
        end
        
        buttonFrame.OnSendKeyEvent = function( _, key, down)
            if key == InputKey.MouseButton0 and down and not MainMenu_GetIsOpened() then
				Shared.ConsoleCommand( string.format( "j%s",teamIndex))
                Shared.PlaySound(nil, "sound/NS2.fev/common/button_enter")
            end
        end    
    end

    SGAddPropertyAnim(self.menu, buttonFrame, kSGColor, notSelectedColor, 0.4)
    SGAddPropertyAnim(self.menu, buttonFrame, kSGPosition, Vector(xOffset, 0, 0), 0.8, SGEaseOutBounce, enableButton)
        
    return buttonFrame
 
end


function LastStand_GUIJoinTeam:Initialize()
    self.updateInterval = 0
    self.menu = SGCreateMenu()
    
    local blackBackground = SGAddGraphic(self.menu)
    SGSetSizeAndCenter(blackBackground, Client.GetScreenWidth(), Client.GetScreenHeight())
    blackBackground:SetColor(Color(0,0,0,1))
    
    local promptWidth, promptHeight = SGGetRegionSize(kChooseTeamAtlas.prompt)
    local spectateWidth = SGGetRegionSize(kChooseTeamAtlas.spectate)
    local marinesWidth, marinesHeight = SGGetRegionSize(kChooseTeamAtlas.marines)
    local borderSize = (promptHeight - marinesHeight) / 2 --6.5
    local menuWidth = promptWidth + 2*marinesWidth + 4*borderSize + kPromptGap + kChooseSideGap
    local menuHeight = promptHeight + kChooseSideGap
    local marinesOffset = promptWidth + kPromptGap
    local aliensOffset = marinesOffset + 2*borderSize + marinesWidth + kChooseSideGap/3
    local marineColor = Color(0, 0, 1, 1)
    local alienColor = Color(1, 0.76, 0.11, 1)
    local notSelectedColor = Color(1, 1, 1, 0.5)
    
    local background = SGAddGraphic(self.menu)
    SGSetSizeAndCenter(background, menuWidth, menuHeight)
    background:SetColor(Color(0, 0, 0, 0))    

    local prompt = SGAddGraphic(self.menu, background, kChooseTeamAtlas.prompt)
    prompt:SetAnchor(GUIItem.Left, GUIItem.Top)
    prompt:SetColor(Color(1, 1, 1, 0))
    SGAddPropertyAnim(self.menu, prompt, kSGColor, Color(1, 1, 1, 0.8), 1.5, SGDelay(SGEaseOutCubic, 1.2, 1.5))

    local spectate = SGAddGraphic(self.menu, background, kChooseTeamAtlas.spectate)
    spectate:SetAnchor(GUIItem.Center, GUIItem.Top)
    spectate:SetColor(Color(1, 1, 1, 0))
    spectate:SetPosition(Vector(-spectateWidth / 2, marinesHeight + kPromptGap, 0))
    
    local logo = SGAddGraphic(self.menu, blackBackground, kLogoAtlas.logo)
    logo:SetAnchor(GUIItem.Center, GUIItem.Top)
    logo:SetColor(Color(1, 1, 1, 0))
    logo:SetPosition(Vector(-kLogoWidth / 4, 30, 0))
    logo:SetSize(Vector(kLogoWidth/2, kLogoHeight/2, 0))
    SGAddPropertyAnim(self.menu, logo, kSGColor, Color(1, 1, 1, 1), 1.5, SGDelay(SGEaseOutCubic, 1.2, 1.5))
    
    local function enableButton()
        spectate.isMouseOver = false
        spectate.OnMouseEnter = function()
            if not MainMenu_GetIsOpened() then
                SGAddPropertyAnim(self.menu, spectate, kSGScale, Vector(1.08, 1.08, 1)) 
                SGAddPropertyAnim(self.menu, spectate, kSGColor, Color(1, 1, 1, 1)) 
                --TODO: Play sound
            end
        end

        spectate.OnMouseExit = function()
            SGAddPropertyAnim(self.menu, spectate, kSGScale, Vector(1, 1, 1)) 
            SGAddPropertyAnim(self.menu, spectate, kSGColor, notSelectedColor)
        end

        spectate.OnSendKeyEvent = function(_, key, down)
            if key == InputKey.MouseButton0 and down and not MainMenu_GetIsOpened() then
                Shared.ConsoleCommand( "spectate" )
                --TODO: Play sound
            end
        end    
    end
    
    SGAddPropertyAnim(self.menu, spectate, kSGColor, Color(1, 1, 1, 0.8), 1.5, SGDelay(SGEaseOutCubic, 1.2, 1.5), enableButton())
	
    self.marines = self:_AddJoinButton(background, marinesOffset, kTeam1Index, kChooseTeamAtlas.marines, borderSize, marineColor, -1)
    self.aliens = self:_AddJoinButton(background, aliensOffset, kTeam2Index, kChooseTeamAtlas.aliens, borderSize, alienColor, 1)
    Shared.PlaySound(nil, kCommonSounds.LoadingMusic)
	self.DisplayMouseTime = Shared.GetTime() + 1
end


function LastStand_GUIJoinTeam:Uninitialize()

    SGDestroyMenu(self.menu)
    self.menu = nil
    
    MouseTracker_SetIsVisible(false)  
    Shared.StopSound(nil, kCommonSounds.LoadingMusic)

end


function LastStand_GUIJoinTeam:Update(deltaTime)
    SGUpdateMenu(self.menu, deltaTime)
	if not self.mouseDisplayed and Shared.GetTime() >= self.DisplayMouseTime then
		MouseTracker_SetIsVisible(true)
		self.mouseDisplayed = true
	end
end

function LastStand_GUIJoinTeam:SendKeyEvent(key, down)
    return SGSendKeyEvent(self.menu, key, down) and key == InputKey.MouseButton0
end

function LastStand_GUIJoinTeam:OnClose()
    Shared.StopSound(nil, kCommonSounds.LoadingMusic)
end
