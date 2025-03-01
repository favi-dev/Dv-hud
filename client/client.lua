


local QBCore = exports[Shared.Core]:GetCoreObject()

while QBCore.Functions.GetPlayerData().name == nil do
    
    Wait(1000)
end

DisplayRadar(false)


local hunger = QBCore.Functions.GetPlayerData().metadata.hunger
local thirst = QBCore.Functions.GetPlayerData().metadata.thirst
local speedMultiplier = 2.23694
local isLowFuelChecked = true
local isMapOpen = false

RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
    hunger = newHunger
    thirst = newThirst
end)

RegisterNetEvent("hud:Client:OpenHudSettings", function()
    SetNuiFocus(true, true)
    Koci.Client:SendReactMessage("setRouter", "settings")
end)
local lastFuelUpdate = 0
local lastFuelCheck = {}

local function getFuelLevel(vehicle)
    while true do
        local updateTick = GetGameTimer()
        if (updateTick - lastFuelUpdate) > 2000 then
            lastFuelUpdate = updateTick
            lastFuelCheck = math.floor(exports[Shared.FuelScript]:GetFuel(vehicle))
        end
        return lastFuelCheck
    end
end
    RegisterNetEvent('hud:client:LoadMap', function()
        Wait(50)
        local defaultAspectRatio = 1920 / 1080
        local resolutionX, resolutionY = GetActiveScreenResolution()
        local aspectRatio = resolutionX / resolutionY
        local minimapOffset = 0
        if aspectRatio > defaultAspectRatio then
            minimapOffset = ((defaultAspectRatio - aspectRatio) / 3.6) - 0.008
        end

        RequestStreamedTextureDict('squaremap', false)
        while not HasStreamedTextureDictLoaded('squaremap') do
            Wait(150)
        end

        SetMinimapClipType(0)
        AddReplaceTexture('platform:/textures/graphics', 'radarmasksm', 'squaremap', 'radarmasksm')
        AddReplaceTexture('platform:/textures/graphics', 'radarmask1g', 'squaremap', 'radarmasksm')
        


SetMinimapComponentPosition('minimap', 'L', 'B', 0.0 + minimapOffset, -0.047, 0.1638, 0.183)

SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.0 + minimapOffset, 0.0, 0.128, 0.20)

SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.01 + minimapOffset, 0.025, 0.262, 0.300)





        SetRadarBigmapEnabled(false, false)
        SetMinimapClipType(0)
        DisplayRadar(true)
    
    
        SetRadarZoom(1100)
    end)

RegisterCommand("hudop",function ()
    TriggerEvent("hud:client:LoadMap")
end)
function CalculateCardinalDirection(heading)
    if heading >= 337.5 or heading < 22.5 then 
        return "N"
    elseif heading >= 22.5 and heading < 67.5 then 
        return "NE"
    elseif heading >= 67.5 and heading < 112.5 then 
        return "E"
    elseif heading >= 112.5 and heading < 157.5 then 
        return "SE"
    elseif heading >= 157.5 and heading < 202.5 then 
        return "S"
    elseif heading >= 202.5 and heading < 247.5 then 
        return "SW"
    elseif heading >= 247.5 and heading < 292.5 then 
        return "W"
    elseif heading >= 292.5 and heading < 337.5 then 
        return "NW"
    end
end
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) and not IsThisModelABicycle(GetEntityModel(GetVehiclePedIsIn(ped, false))) then
                if exports[Shared.FuelScript]:GetFuel(GetVehiclePedIsIn(ped, false)) <= 20 then -- At 20% Fuel Left
                    if isLowFuelChecked then
                        TriggerServerEvent("InteractSound_SV:PlayOnSource", "pager", 0.10)
                        lib.notify({
                            id = 'some_identifier',
                            title = '',
                            description = "Fuel Level Low!",
                            showDuration = false,
                            position = 'top',
                            style = {
                                backgroundColor = '#141517',
                                color = '#C1C2C5',
                                ['.description'] = {
                                  color = '#909296'
                                }
                            },
                            icon = 'fa-solid fa-gas-pump',
                            iconColor = '#C53030'
                        })
                        Wait(60000) 
                    end
                end
            end
        end
        Wait(10000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local channel = 0

        QBCore.Functions.TriggerCallback('getradio', function(c)
            channel = c
        end)

        Wait(100)
        
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed)
        local heading = GetEntityHeading(playerPed)
        local compass = CalculateCardinalDirection(heading)
        local walk = math.floor(GetPlayerStamina(PlayerId()))

        if walk <= 0 then
            lib.notify({
                id = 'some_identifier',
                title = '',
                description = "You can't run, you're tired",
                showDuration = false,
                position = 'top',
                style = {
                    backgroundColor = '#141517',
                    color = '#C1C2C5',
                    ['.description'] = {
                      color = '#909296'
                    }
                },
                icon = 'fa-solid fa-person-walking',
                iconColor = '#C53030'
            })
        end

        if not isMapOpen then
            SendNUIMessage({
                type = "Direction",
                heading = compass,
                fuel = getFuelLevel(vehicle),
            })
        end

        local health = GetEntityHealth(playerPed) - 100
    
        local armor = GetPedArmour(playerPed)

        local talking = NetworkIsPlayerTalking(PlayerId())

        local voice = 0
        if LocalPlayer.state['proximity'] then
            voice = LocalPlayer.state['proximity'].distance
        end
        local walk = math.floor(GetPlayerStamina(PlayerId()))
        if not isMapOpen then
            SendNUIMessage({
                type = "Update",
                health = health,
                armor = armor,
                hunger = hunger,
                thirst = thirst,
                walk = walk,
            
                mic = {
                    voice = voice,
                    talking = talking,
                    radio = channel,
                    alt = LocalPlayer.state["radioActive"]
                }
            })
        end
    end
end)

RegisterNetEvent(Shared.Voice..':clSetPlayerRadio', function (channel)
    print(channel)
end)


CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local speed = GetEntitySpeed(GetVehiclePedIsIn(ped, false)) * speedMultiplier
                local stressSpeed = seatbeltOn and Shared.MinimumSpeed or Shared.MinimumSpeedUnbuckled
                if speed >= stressSpeed then
                    TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                end
            end
        end
        Wait(10000)
    end
end)

local function IsWhitelistedWeaponStress(weapon)
    if weapon then
        for _, v in pairs(Shared.WhitelistedWeaponStress) do
            if weapon == v then
                return true
            end
        end
    end
    return false
end
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local ped = GetPlayerPed(-1)
        local inVehicle = IsPedInAnyVehicle(ped, false)

        if not isMapOpen then
            SendNUIMessage({
                vehride = "yes",
              
              
              
              
              
                inVehicle = inVehicle
            })
        end
    end
end)
CreateThread(function() 
    while true do
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
            if weapon ~= `WEAPON_UNARMED` then
                if IsPedShooting(ped) and not IsWhitelistedWeaponStress(weapon) then
                    if math.random() < Shared.StressChance then
                        TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                    end
                    Wait(100)
                else
                    Wait(500)
                end
            else
                Wait(1000)
            end
        else
            Wait(1000)
        end
    end
end)



local function GetBlurIntensity(stresslevel)
    for k, v in pairs(Shared.Intensity['blur']) do
        if stresslevel >= v.min and stresslevel <= v.max then
            return v.intensity
        end
    end
    return 1500
end



SetBlipAlpha(GetNorthRadarBlip(), 0)




local function GetEffectInterval(stresslevel)
    for k, v in pairs(Shared.EffectInterval) do
        if stresslevel >= v.min and stresslevel <= v.max then
            return v.timeout
        end
    end
    return 60000
end

-- CreateThread(function()
--     while true do
--         if LocalPlayer.state.isLoggedIn then
--             local ped = PlayerPedId()
--             local effectInterval = GetEffectInterval(stress)
--             if stress >= 100 then
--                 local BlurIntensity = GetBlurIntensity(stress)
--                 local FallRepeat = math.random(2, 4)
--                 local RagdollTimeout = FallRepeat * 1750
--                 TriggerScreenblurFadeIn(1000.0)
--                 Wait(BlurIntensity)
--                 TriggerScreenblurFadeOut(1000.0)

--                 if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
--                     SetPedToRagdollWithFall(ped, RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
--                 end

--                 Wait(1000)
--                 for i = 1, FallRepeat, 1 do
--                     Wait(750)
--                     DoScreenFadeOut(200)
--                     Wait(1000)
--                     DoScreenFadeIn(200)
--                     TriggerScreenblurFadeIn(1000.0)
--                     Wait(BlurIntensity)
--                     TriggerScreenblurFadeOut(1000.0)
--                 end
--             elseif stress >= Shared.MinimumStress then
--                 local BlurIntensity = GetBlurIntensity(stress)
--                 TriggerScreenblurFadeIn(1000.0)
--                 Wait(BlurIntensity)
--                 TriggerScreenblurFadeOut(1000.0)
--             end
--             Wait(effectInterval)
--         else
--             Wait(1000)
--         end
--     end
-- end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local playerPed = PlayerPedId()
        local maxStamina = 100
        local stamina = GetPlayerSprintStaminaRemaining(PlayerId())
        local staminaPercentage = (stamina / maxStamina) * 100
        
        if not isMapOpen then
            SendNUIMessage({
                action = "updateStamina",
                stamina = staminaPercentage
            })
        end
    end
end)

Citizen.CreateThread(function ()
    
    local playerHealth = GetEntityHealth(playerPed) - 100
    local playerArmor = GetPedArmour(playerPed)
    local walk = math.floor(GetPlayerStamina(PlayerId()))


    local playerHunger = 100 
    local playerThirst = 100 
    local playerStress = 0   
    SendNUIMessage(json.encode({
        healthtest = playerHealth,
        armortest = playerArmor,
        hungertest = playerHunger,
        thirsttest = playerThirst,
        stresstest = playerStress,
        walk = walk

    }))
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local ped = GetPlayerPed(-1)
        local inVehicle = IsPedInAnyVehicle(ped, false)

        if not isMapOpen then
            SendNUIMessage({
                type = "vehicleStatus",
                inVehicle = inVehicle
            })
        end
    end
end)


SetBlipAlpha(GetNorthRadarBlip(), 0)





RegisterNetEvent('map:client:ToggleMap', function(state)
    local isMapOpen = state
    if isMapOpen then
        SendNUIMessage({ action = "hideUI" }) 
        
    else
        SendNUIMessage({ action = "showUI" }) 
    end
end)



local minimapEnabled = false


local function HandleMinimap(shouldShow)
    if shouldShow then
        DisplayRadar(true)
        SetRadarBigmapEnabled(false, false)
        minimapEnabled = true
        TriggerEvent("hud:client:LoadMap")
    else
        DisplayRadar(false)
        SetRadarBigmapEnabled(false, false)
        minimapEnabled = false
    end
end


CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if vehicle ~= 0 then
            if not isMapOpen then
                isMapOpen = true
                DisplayRadar(true)
                SetRadarBigmapEnabled(false, false)
                TriggerEvent("hud:client:LoadMap")
            end
        else
            if isMapOpen then
                isMapOpen = false
                DisplayRadar(false)
                SetRadarBigmapEnabled(false, false)
            end
        end
    end
end)


RegisterNetEvent("hud:client:LoadMap")
AddEventHandler("hud:client:LoadMap", function()
    DisplayRadar(true)
    SetRadarBigmapEnabled(false, false)
end)

local function saveSettings()
    SetResourceKvp('hudSettings', json.encode(Menu))
end



function getengine()
    if GetIsVehicleEngineRunning(GetVehiclePedIsIn(PlayerPedId())) then
        return true
    else
        return false
    end
end

Citizen.CreateThread(function()
    
    local previousVeh = nil
    while true do
        Citizen.Wait(100)  

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsUsing(ped) 


        if IsPedInAnyVehicle(ped, false) and not IsThisModelABicycle(vehicle) then
 
            local vehspeed = GetEntitySpeed(vehicle) * 3.6 
            local fuel = GetVehicleFuelLevel(vehicle) 
            local CheckHarnass = exports['qb-smallresources']:HasHarness()
            local CheckSeatbelt = exports['qb-smallresources']:HasSeatbelt()
            local gear = GetVehicleCurrentGear(vehicle)  
            local engine = getengine()


            if vehicle ~= previousVeh then
                previousVeh = vehicle
               
            end


            SendNuiMessage(json.encode({
                vehud = "open",
                vehspeed = vehspeed,
                fuel = fuel,          
                gear = gear,         
                engine = engine,      
                setbelt = CheckSeatbelt 
            }))
        else

            SendNuiMessage(json.encode({
                vehud = "close"
            }))
        end
    end
end)



Citizen.CreateThread(function ()
    while true do
      
        
        if IsPauseMenuActive() then
            SendNUIMessage({ action = "hideUI" })

        end


        Wait(100)
    end
end)



-- Citizen.CreateThread(function ()
--     TriggerEvent("hud:client:LoadMap")
-- end)
