function CloakableMixin:GetIsCloaked()
    -- LastStand_ consider "cloaked" to AI if still walking
    return self.cloakFraction > 0.2
end