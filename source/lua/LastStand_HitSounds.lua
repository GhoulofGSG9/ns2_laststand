if Server then
local kHitSoundEnabledForWeaponModded =
    set {
        kTechId.Axe, kTechId.Welder, kTechId.Pistol, kTechId.Rifle, kTechId.Shotgun, kTechId.Flamethrower, kTechId.GrenadeLauncher,
        kTechId.Claw, kTechId.Minigun, kTechId.Railgun, 
        kTechId.Bite, kTechId.Parasite, kTechId.Xenocide, 
        kTechId.Spit, 
        kTechId.LerkBite, kTechId.Spikes, 
        kTechId.Swipe, kTechId.Stab, 
        kTechId.Gore,
        
        kTechId.DropShotgun, 
        kTechId.DropFlamethrower,
        kTechId.DropMines,
        kTechId.DropGrenadeLauncher,
    }
    
ReplaceLocals(HitSound_IsEnabledForWeapon, { kHitSoundEnabledForWeapon = kHitSoundEnabledForWeaponModded })
end