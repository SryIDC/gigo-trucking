RegisterNetEvent("gigo-trucking:server:endJob", function (money)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not (Player or Job[Player.PlayerData.citizenid]) then return end
    Player.Functions.AddMoney('cash', money, "Trucking job paycheck")
    Notification("Trucking", ("You have completed the contract successfully and earned $: %s !"):format(money), 8000, "success")
end)