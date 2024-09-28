RegisterNetEvent("gigo-trucking:server:reward", function ()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    Player.Functions.AddMoney('cash', money)
    TriggerClientEvent('ox_lib:notify', src, {
        title = "Trucking",
        description = ("You have successfully completed the contract and received your payment: $%s"):format(money) ,
        type = "success",
        duration = 8000})
end)