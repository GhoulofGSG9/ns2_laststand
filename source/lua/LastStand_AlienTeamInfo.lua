--Todo: Fix lua/GUIUpgradeChamberDisplay.lua locals everywhere :(

function AlienTeamInfo:OnUpdate(deltaTime)

    TeamInfo.OnUpdate(self, deltaTime)

    self.numHives = 3
    self.bioMassLevel = math.min(GetGameInfoEntity():GetWave(), 12)
    self.bioMassAlertLevel = 0
    self.maxBioMassLevel = 12
    self.veilLevel = math.floor(Clamp(GetGameInfoEntity():GetWave() / 3, 0, 3))
    self.spurLevel = self.veilLevel
    self.shellLevel = self.veilLevel
end