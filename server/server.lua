


local QBCore = exports[Shared.Core]:GetCoreObject()

local ResetStress = false

-- RegisterNetEvent('hud:server:GainStress', function(amount)
--     local src = source
--     local Player = QBCore.Functions.GetPlayer(src)
--     local newStress
--     if not Player or (Shared.DisablePoliceStress and Player.PlayerData.job.name == 'police') then return end
--     if not ResetStress then
--         if not Player.PlayerData.metadata['stress'] then
--             Player.PlayerData.metadata['stress'] = 0
--         end
--         newStress = Player.PlayerData.metadata['stress'] + amount
--         if newStress <= 0 then newStress = 0 end
--     else
--         newStress = 0
--     end
--     if newStress > 100 then
--         newStress = 100
--     end
--     Player.Functions.SetMetaData('stress', newStress)
--     TriggerClientEvent('hud:client:UpdateStress', src, newStress)
--     TriggerClientEvent(Shared.CoreObj..':Notify', src, 'Feeling More Stressed', 'error', 1500)
-- end)

-- RegisterNetEvent('hud:server:RelieveStress', function(amount)
--     local src = source
--     local Player = QBCore.Functions.GetPlayer(src)
--     local newStress
--     if not Player then return end
--     if not ResetStress then
--         if not Player.PlayerData.metadata['stress'] then
--             Player.PlayerData.metadata['stress'] = 0
--         end
--         newStress = Player.PlayerData.metadata['stress'] - amount
--         if newStress <= 0 then newStress = 0 end
--     else
--         newStress = 0
--     end
--     if newStress > 100 then
--         newStress = 100
--     end
--     Player.Functions.SetMetaData('stress', newStress)
--     TriggerClientEvent('hud:client:UpdateStress', src, newStress)
--     TriggerClientEvent(Shared.CoreObj..':Notify', src, 'Feeling More Realeaxed', 'success', 1500)
-- end)

QBCore.Functions.CreateCallback('getradio', function(source, cb)
    cb(Player(source).state.radioChannel)
end)