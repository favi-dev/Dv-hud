


Shared = {}

Shared.Core = 'qb-core'--اسم الكور حقك
Shared.CoreObj = 'QBCore' 
Shared.Voice = "qb-voice"  --'pma-voice' 
Shared.StressChance = 0 -- Default: 10% --
Shared.MinimumStress = 100
Shared.MinimumSpeedUnbuckled = 50
Shared.MinimumSpeed = 100 
Shared.DisablePoliceStress = false 
Shared.FuelScript = 'LegacyFuel' --[cdn-fule]--[LegacyFuel] fuel script naem -- اسم سكربت البنزين

Shared.WhitelistedWeaponStress = {
    `weapon_petrolcan`,
    `weapon_hazardcan`,
    `weapon_fireextinguisher`
}

Shared.Intensity = {
    ["blur"] = {
        [1] = {
            min = 50,
            max = 60,
            intensity = 1500,
        },
        [2] = {
            min = 60,
            max = 70,
            intensity = 2000,
        },
        [3] = {
            min = 70,
            max = 80,
            intensity = 2500,
        },
        [4] = {
            min = 80,
            max = 90,
            intensity = 2700,
        },
        [5] = {
            min = 90,
            max = 100,
            intensity = 3000,
        },
    }
}

Shared.EffectInterval = {
    [1] = {
        min = 50,
        max = 60,
        timeout = math.random(50000, 60000)
    },
    [2] = {
        min = 60,
        max = 70,
        timeout = math.random(40000, 50000)
    },
    [3] = {
        min = 70,
        max = 80,
        timeout = math.random(30000, 40000)
    },
    [4] = {
        min = 80,
        max = 90,
        timeout = math.random(20000, 30000)
    },
    [5] = {
        min = 90,
        max = 100,
        timeout = math.random(15000, 20000)
    }
}
