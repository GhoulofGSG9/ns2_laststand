local grenadethrower_oncreate = GrenadeThrower.OnCreate
function GrenadeThrower:OnCreate()

    grenadethrower_oncreate(self)    
    InitMixin(self, PickupableWeaponMixin)

end

function GrenadeThrower:GetIsValidRecipient(player)

    if player and HasMixin(player, "WeaponOwner") then

        local hasGrenade = false
        
        for _, weapon in ipairs(player:GetWeapons()) do
        
            if weapon:isa("GrenadeThrower") then
                hasGrenade = true
                break
            end
        
        end
        
        if not hasGrenade then
            return true
        end

    end    

    return false

end

