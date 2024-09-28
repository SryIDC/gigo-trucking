function SpawnPed()
    if DoesEntityExist(pedModel) then return end

    local SpawnLoc = Config.Ped.location
    local pedModel = Config.Ped.model
    local pedhash = GetHashKey(pedModel)
    lib.requestModel(pedModel, 2000)

    while not HasModelLoaded(pedhash) do
        Wait(1000)
    end

    local JobPed = CreatePed(-1, pedhash, SpawnLoc.x, SpawnLoc.y, SpawnLoc.z-1.0, SpawnLoc.w, true, false)
    SetBlockingOfNonTemporaryEvents(JobPed, false)
    FreezeEntityPosition(JobPed, true)
    SetEntityInvincible(JobPed, true)

    exports.ox_target:addLocalEntity(JobPed, {
        label = "Start Job",
        canInteract = function ()
            return not onJob
        end,
        onSelect = function ()
            OpenMenu()
        end
    })
end

function PlayerLogout()
    onJob = false
end

function Notification(description, type, duration)
    if Config.NotificationType == "ox_lib" then
        lib.notify({
            title = "Trucking Contractor", 
            description = description,
            type = type,
            duration = duration,
        })
    elseif Config.NotificationType == "qbx_core" then
        exports.qbx_core:Notify(description, type, duration)
    end
end

function CreateRoute(coords, text)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 5)
    SetBlipScale(blip, 1.0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    SetBlipAsShortRange(blip, true)

    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 5)
    return blip
end