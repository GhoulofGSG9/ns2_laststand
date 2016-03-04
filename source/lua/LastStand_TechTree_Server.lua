
--Unlock researchs either directly or based on biomass
TechTree.AddResearchNode = TechTree.AddActivation

--Everything is avaible to be bought from the start
function TechTree:AddBuyNode(techId, _, _, addOnTechId)
    local techNode = TechNode()

    techNode:Initialize(techId, kTechType.Buy)

    if addOnTechId then
        techNode.addOnTechId = addOnTechId
    end

    self:AddNode(techNode)
end

TechTree.AddTargetedBuyNode = TechTree.AddBuyNode