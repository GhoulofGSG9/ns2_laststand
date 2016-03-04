local oldInitialize = GUIFirstPersonSpectate.Initialize
function GUIFirstPersonSpectate:Initialize()
	oldInitialize(self)

	local kSize = GUIScale(Vector(220,60,0))
	self.background:SetPosition(Vector(-kSize.x/2,kSize.y,0))
end

