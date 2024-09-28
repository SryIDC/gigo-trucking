local jobTruck
local trailerDeliveryLOC
local jobTrailer
local pickupLOC
local trailerAttached = false
local jobTruckDeleteZone
local trailerDeliveryZone
local availJobs = Config.Job.trailer
local jobMenu
local hasTrailer, trailerEntity = nil, nil


-- Start of Functions
local function JobGenerator()
    local selected = {}
    local tempList = {}

    for i, v in ipairs(availJobs) do
        table.insert(tempList, v)
    end

    -- Select 3 random jobs
    for i = 1, 3 do
        if #tempList == 0 then
            break
        end

        local randIndex = math.random(1, #tempList)
        table.insert(selected, table.remove(tempList, randIndex))
    end

    return selected
end



--Spawn job Vehicle
local function SpawnJobVehicle(GJob)
    local truckSpawn = Config.Job.truckSpawn
    lib.requestModel(GJob.truck, 5000)

    local playerPed = PlayerPedId()
    local truckhash = GetHashKey(GJob.truck)
    
    jobTruck = CreateVehicle(truckhash, truckSpawn.x, truckSpawn.y, truckSpawn.z, truckSpawn.w, true, false)
    TaskWarpPedIntoVehicle(playerPed, jobTruck, -1)
    Notification("Trucking", "Drive to the pickup location!", 8000, "inform")
    SetVehicleEngineOn(jobTruck, true, true, false)
end

local function SpawnJobTrailer(GJob)
    lib.requestModel(GJob.trailer, 5000)

    local pickup = GJob.pickup
    local trailerLoc = pickup
    local trailerHash = GetHashKey(GJob.trailer)
    
    jobTrailer = CreateVehicle(trailerHash, pickup.x, pickup.y, pickup.z, pickup.w, true, false)
    SetVehicleEngineOn(jobTrailer, true, true, false)

    pickupLOC = CreateBlip(trailerLoc, 1, 5, 1.0, "Trailer")
end

function EndJob()
    local playerPed = PlayerPedId()
    local money = GJob.payment
    if DoesBlipExist(trailerDeliveryLOC) then
        RemoveBlip(trailerDeliveryLOC)
    end
    if DoesBlipExist(jobTruckDeleteZone) then
        RemoveBlip(jobTruckDeleteZone)
    end
    deleteVehZone = lib.points.new({
        coords = vec3(1202.7256, -3241.0471, 5.96710),
        distance = 8,
        onEnter = function (self)
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle == jobTruck then
                trailerAttached = false
                TriggerServerEvent("gigo-trucking:server:endJob", money)
                TaskLeaveVehicle(cache.ped, vehicle, 0)
                Wait(1000)
                if DoesEntityExist(jobTruck) then
                    DeleteEntity(jobTruck)
                end
                if DoesBlipExist(jobTruckDeleteZone) then   
                    RemoveBlip(jobTruckDeleteZone)
                end
                Job = false
                GJob = nil
                hasTrailer, trailerEntity = nil, nil
                deleteVehZone:remove()
            end
            
        end
    })

    local delT = Config.Job.deletetruck

    jobTruckDeleteZone = CreateBlip(delT, 1, 5, 1.0, "Drop Truck")
end

function RegisterJobMenu()

    local jobs = JobGenerator()
    jobMenu = {}

    for i, job in ipairs(jobs) do
        table.insert(jobMenu, {
            label = job.label,
            description = "Payment: $"..job.payment,
            args = job
        })
    end

    lib.registerMenu({
        id = 'trucking_jobs_menu',
        title = 'Available Jobs',
        position = "top-right",
        options = jobMenu
    }, function(selected)
        local selectedJob = jobMenu[selected]
        GJob = selectedJob.args
        TriggerEvent("gigo-trucking:client:acceptContract", GJob)
    end)
end

local function TrailerPickedUP()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle and DoesEntityExist(jobTrailer) then 
        hasTrailer, trailerEntity = GetVehicleTrailerVehicle(vehicle)

        if hasTrailer and DoesEntityExist(trailerEntity) then
            if DoesBlipExist(pickupLOC) then
                RemoveBlip(pickupLOC)
            end
            Notification("Trucking", "Trailer attached!", 5000, "success")
            trailerAttached = true
            TriggerEvent("gigo-trucking:client:startDropRide")
        elseif trailerAttached then
            Notification("Trucking", "You already have a trailer attached.", 3000, "inform")
        end
    end
end


--Functions End



--Start of Events


--Accepting Contract
RegisterNetEvent("gigo-trucking:client:acceptContract", function (GJob)
    JobGenerator()
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
        Job = true
        SpawnJobVehicle(GJob)
        SpawnJobTrailer(GJob)
     end
    
end)

--Checking if trailer has been attached to truck
CreateThread(function ()
    while not trailerAttached do
        Wait(500)
        TrailerPickedUP()
    end
end)

--Picking up trailer and heading to delivery point
RegisterNetEvent("gigo-trucking:client:startDropRide", function ()
    local playerPed = PlayerPedId()
    trailerDeliveryZone = lib.zones.box({
        coords = vec3(GJob.drop.x, GJob.drop.y, GJob.drop.z),
        size = vec3(8,8,8),
        onEnter = function ()
            if IsVehicleAttachedToTrailer(jobTruck) then
                FreezeEntityPosition(jobTruck, true)
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
                    DetachVehicleFromTrailer(jobTruck)
                    
                    FreezeEntityPosition(cache.vehicle, false)
                    EndJob()
                    if DoesBlipExist(trailerDeliveryLOC) then
                        RemoveBlip(trailerDeliveryLOC)
                    end
                    DeleteEntity(jobTrailer)
                    Notification("Trucking", "You have completed your contract!\n Get Back to the contracter and deliver the vehicle!", 5000, "success")
                    trailerDeliveryZone:remove()
                 end
            end
        end
    })

    trailerDeliveryLOC = CreateBlip(GJob.drop, 1, 5, 1.0, "Delivery Location")
end)
RegisterJobMenu()
