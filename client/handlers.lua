AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    SpawnPed()
    print("spawned ped")
end)

RegisterNetEvent('qbx_core:client:playerLoggedOut', function()
    if onJob then
        PlayerLogout()
    end
end)