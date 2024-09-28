onJob = false
local Contract
local JobTruck
local JobTrailer
local trailerAttached = false

local function RequestModel(model, timeout)
    lib.requestModel(model, timeout)
    local hash = model

    while not HasModelLoaded(hash) do
        Wait(1000)
    end

    return hash
end

function OpenMenu()
    local randomJobs = lib.callback.await("gigo-trucking:client:RandomJob", false)
    local jobMenu = {}

    for i, job in ipairs(randomJobs) do
        table.insert(jobMenu, {
            label = job.label,
            description = "Payment: $"..job.payment,
            args = job
        })
    end

    lib.registerMenu({
        id = "openTruckingMenu",
        title = "Available Jobs",
        position = "top-right",
        options = jobMenu
    }, function (selected)
        local selectedJob = jobMenu[selected]
        Contract = selectedJob.args
        TriggerEvent("gigo-trucking:client:AcceptContract")
    end)
end

local function SpawnJobVehicles()
    local Truck = RequestModel(Contract.truckModel, 5000)
    local Trailer = RequestModel(Contract.trailerModel, 5000)
    local TruckPickup = Config.Job.TruckSpawnLoc
    local TrailerPickup = Contract.pickup
    JobTruck = CreateVehicle(Truck, TruckPickup.x, TruckPickup.y, TruckPickup.z, TruckPickup.w, true, false)
    JobTrailer = CreateVehicle(Trailer, TrailerPickup.x, TrailerPickup.y, TrailerPickup.z, TrailerPickup.w, true, false)
end

RegisterNetEvent( "gigo-trucking:client:AcceptContract",function()
    SpawnJobVehicles()

    if lib.progressBar({
        duration = 5000,
        label = 'Accepting contract',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
        },
        anim = {
            dict = 'missfam4',
            clip = 'base'
        },
        prop = {
            model = `p_amb_clipboard_01`,
            bone = 36029,
            pos = vec3(0.16, 0.08, 0.1),
            rot = vec3(-130.0, -50.0, 0.0)
        },
    }) then 
        onJob = true
        TriggerEvent("gigo-trucking:client:startJob")
     end
end)

RegisterNetEvent("gigo-trucking:client:startJob", function ()
    local TrailerLoc = CreateRoute(Contract.trailerPickUpLocation, "Trailer")
    TaskWarpPedIntoVehicle(cache.ped, JobTruck, -1)
    Notification("Drive to the trailer's location and attach trailer to the truck!", "inform", 8000)
    CheckTrailerStatus()
end)

function CheckTrailerStatus()
    while not trailerAttached do
        Wait(500)
        TriggerEvent("gigo-trucking:client:trailerAttached")
    end
end

RegisterNetEvent("gigo-trucking:client:trailerAttached", function ()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle and DoesEntityExist(jobTrailer) then 
        local hasTrailer, trailerEntity = GetVehicleTrailerVehicle(vehicle)
        if hasTrailer and DoesEntityExist(trailerEntity) then
            if DoesBlipExist(TrailerLoc) then
                RemoveBlip(TrailerLoc)
            end
            Notification("Trailer attached!", 5000, "success")
            trailerAttached = true
            TriggerEvent("gigo-trucking:client:DeliveryStart")
        end
    end
end)

RegisterNetEvent("gigo-trucking:client:DeliveryStart", function ()
    local DropLoc = Contract.trailerDropLocation
    local DeliveryBlip = CreateRoute(DropLoc, "Delivery Location")
    local DeliveryPoint = lib.points.new({
        coords = vec3(DropLoc.x, DropLoc.y, DropLoc.z),
        distance = 2.0,
        onEnter = function ()
            if GetVehiclePedIsIn(cache.ped, false) == JobTruck and IsPedInAnyVehicle(cache.ped, false) then
                lib.showTextUI("[E] - Deliver trailer!", {
                    icon = "fa-solid fa-trailer"
                })
                if IsControlJustReleased(0, 38) then
                    if lib.progressBar({
                        duration = 5000,
                        label = 'Detaching trailer...',
                        useWhileDead = false,
                        canCancel = false,
                        disable = {
                            car = true,
                            move = true,
                        },
                    }) then 
                        if DoesEntityExist(JobTrailer) then
                            DeleteEntity(JobTrailer)
                        end
                        if DoesBlipExist(DeliveryBlip) then
                            RemoveBlip(DeliveryBlip)
                        end
                        TriggerEvent("gigo-trucking:client:TruckDelivery")
                        DeliveryPoint:remove()
                     end
                end
            end
        end,
        onExit = function ()
            lib.hideTextUI()
        end
    })
end)

RegisterNetEvent("gigo-trucking:client:TruckDelivery", function ()
    local TruckDeliveryLoc = Config.Job.TruckDelivery
    local TruckDeliveryBlip = CreateRoute(TruckDeliveryLoc, "Deliver truck here")
    local TruckDeliveryZone = lib.points.new({
        coords = vec3(TruckDeliveryLoc.xyz),
        distance = 2.0,
        onEnter = function ()
            if IsPedInAnyVehicle(cache.ped, false) and GetVehiclePedIsIn(cach.ped, false) == JobTruck then
                FreezeEntityPosition(JobTruck, true)
                TaskLeaveVehicle(cache.ped, JobTruck, 0)
                Wait(5000)
                FreezeEntityPosition(JobTruck, false)
                if DoesEntityExist(JobTruck) then
                    DeleteEntity(JobTruck)
                end
                if DoesBlipExist(TruckDeliverBlip) then 
                    RemoveBlip(TruckDeliveryBlip)
                end
                TriggerServerEvent("gigo-trucking:server:reward", Contract.payment)
                TruckDeliveryZone:remove()
            end
        end
    })
end)

function CleanUp()
    if DoesEntityExist(JobTruck) then
        DeleteEntity(JobTruck)
    end
    if DoesEntityExist(JobTrailer) then
        DeleteEntity(JobTruck)
    end
    if DoesBlipExist(TrailerLoc) then
        RemoveBlip(TrailerLoc)
    end
    if DoesBlipExist(TruckDeliveryBlip) then
        RemoveBlip(TruckDeliveryBlip)
    end
    DeliveryPoint:remove()
    TruckDeliveryZone:remove()
    onJob = false
    trailerAttached = false
end