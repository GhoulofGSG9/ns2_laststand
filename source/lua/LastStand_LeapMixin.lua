function LeapMixin:GetHasSecondary(player)
    return GetIsTechUnlocked( player, kTechId.Leap )
end