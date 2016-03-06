local initialize_alienteam = AlienTeam.Initialize
function AlienTeam:Initialize(teamName, teamNumber)

    if initialize_alienteam then
        initialize_alienteam(self, teamName, teamNumber)
    end

    self.respawnEntity = AlienSpectator.kMapName

end

function AlienTeam:GetBioMassLevel()
    return GetGameInfoEntity():GetWave()
end

function AlienTeam:GetSpawnPosition()
    local spawn = gAlienSpawns[math.random(#gAlienSpawns)]
    return spawn:GetOrigin()
end

function AlienTeam:GetSpawn()
    return gAlienSpawns and gAlienSpawns[math.random(#gAlienSpawns)]
end

function AlienTeam:GetSpawnAngles()
    return gAlienSpawn[1]:GetAngles()
end

function AlienTeam:GetActiveHiveCount()
    return 3
end

function AlienTeam:GetNumHives()
    return 3
end

local kBioMassTechIds =
{
    kTechId.BioMassOne,
    kTechId.BioMassTwo,
    kTechId.BioMassThree,
    kTechId.BioMassFour,
    kTechId.BioMassFive,
    kTechId.BioMassSix,
    kTechId.BioMassSeven,
    kTechId.BioMassEight,
    kTechId.BioMassNine
}

function AlienTeam:UpdateBioMassLevel()

    local lastBioMassLevel = self.bioMassLevel

    self.bioMassLevel = GetGameInfoEntity():GetWave()
    self.bioMassAlertLevel = 0
    self.bioMassFraction = 1
    
    if self.techTree then
    
        for i = 1, #kBioMassTechIds do
        
            local techId = kBioMassTechIds[i]
            local techNode = self.techTree:GetTechNode(techId)
            if techNode then
                techNode:SetResearchProgress(1.0)
                self.techTree:SetTechNodeChanged(techNode, string.format("researchProgress = %.2f", 1.0)) 
            end
        
        end
    
    end


    if lastBioMassLevel ~= self.bioMassLevel and self.techTree then
        self.techTree:SetTechChanged()
    end
    
    self.maxBioMassLevel = 12
    
end