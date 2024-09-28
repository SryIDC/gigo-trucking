function Notification(title, description, duration, type)
    local src = source
    if Config.NotificationType == "ox_lib" then
        TriggerClientEvent('ox_lib:notify', src, {
            title = title or "Trucking",
            description = description ,
            type = type or "inform",
            duration = duration or 5000})
    elseif Config.NotificationType == "qbx_core" then
        exports.qbx_core:Notify(title or "Trucking", type or "inform", duration or 5000, description)
    end
end