function Notification(title, description, duration, type)
    if Config.NotificationType == "ox_lib" then
        lib.notify({
            title = title or "Trucking",
            description = description,
            duration = duration or 5000,
            type = type or "inform",
        })
    elseif Config.NotificationType == "qbx_core" then
        exports.qbx_core:Notify(title or "Trucking", type or "inform", duration or 5000, description)
    end
end