function ConfigGunShotEffects_Init( value )
    value.recoil_knockback = 0
end

function ConfigGunShotEffects_PassToGame( value )
    RegisterGunShotEffects(
        value.recoil_knockback
  )
end
function ConfigGunShotEffects_ReadToLua( recoil_knockback )
    __globaldata = {}
    __globaldata.recoil_knockback = recoil_knockback
end
function ConfigGunShotEffects_Copy( source, dest )
    dest.recoil_knockback = source.recoil_knockback
end
