--needs fixing
EngineToDeviceDamage = function()
   for index, ProjectileTable in ipairs(Projectiles) do
      if ProjectileTable.WeaponDamageBonus then
        local multiplier
         if ProjectileTable.DeviceDamageBonus then
            multiplier = 1 / ((ProjectileTable.WeaponDamageBonus + ProjectileTable.ProjectileDamage + ProjectileTable.DeviceDamageBonus) / ProjectileTable.ProjectileDamage + ProjectileTable.DeviceDamageBonus)
         else
            multiplier = 1 / ((ProjectileTable.WeaponDamageBonus + ProjectileTable.ProjectileDamage) / ProjectileTable.ProjectileDamage)
         end
         if not ProjectileTable.DamageMultiplier then ProjectileTable.DamageMultiplier = {} end
         table.insert(ProjectileTable.DamageMultiplier,{ SaveName = "engine_wep", Direct = multiplier, })
      end
   end
end
RegisterApplyMod(EngineToDeviceDamage)


local turretCannon = DeepCopy(FindProjectile("cannon"))

turretCannon.SaveName = "turretCannon"
turretCannon.ProjectileDamage = 1100
turretCannon.ProjectileSplashDamage = 100
turretCannon.ProjectileSplashDamageMaxRadius = 400
turretCannon.ProjectileThickness = 15
turretCannon.SpeedIndicatorFactor = 1
turretCannon.BeamTileRate = 0.05

table.insert(Projectiles, turretCannon)

MakeFlamingVersion("turretCannon", 1.25, 0.4, flamingTrail, 80, nil, nil)




--META MODDING EXAMPLE

-- table.insert(Projectiles, {
--    LCWheelStats = [[[
--    {
--       "radius":75,
--       "spring":35000,
--       "wheelSprite":"mods/lcr/effects/wheel.lua",
--       "dampening":3000,
--       "traction":100,
--       "mass":100,
--       "saveName":"smallSuspension",
--       "height":75,
--       "isInverted":false,
--       "sprocketSprite":"mods/lcr/effects/track_sprocket.lua",
--       "bearingEnergyLoss":0.01
--    },
--    {
--       "radius":75,
--       "spring":30000,
--       "wheelSprite":"mods/lcr/effects/wheel.lua",
--       "dampening":3000,
--       "traction":100,
--       "mass":100,
--       "saveName":"suspension",
--       "height":150,
--       "isInverted":false,
--       "sprocketSprite":"mods/lcr/effects/track_sprocket.lua",
--       "bearingEnergyLoss":0.01
--    },
--    {
--       "saveName":"largeSuspension",

--       "radius":400,
--       "spring":60000,
--    },
--    {
--       "saveName":"battery",

--       "radius":400,
--       "spring":60000,
--    }
--    ]] .. "]"
-- })