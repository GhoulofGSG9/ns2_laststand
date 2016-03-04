class 'LastStand_DropPulseGrenade' (ScriptActor)

function LastStand_DropPulseGrenade:OnCreate()

    ScriptActor.OnCreate(self)    
    InitMixin(self, PickupableWeaponMixin)
    
    self.weaponWorldState = true

end