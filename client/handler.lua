local bossloc = Config.Boss.location
Job = false
local function BossNPC()
    lib.requestModel(Config.Boss.ped, 5000)
    local bossnpchash = GetHashKey(Config.Boss.ped)
    local npc = CreatePed(0, bossnpchash, bossloc.x, bossloc.y, bossloc.z-1.0, bossloc.w, true, false)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetEntityAsMissionEntity(npc, true, true)

    while not DoesEntityExist(npc) do
        Wait(100)
    end

    exports.ox_target:addLocalEntity(npc, {
        {
            label = "Job Menu",
            name = "gigo-trucking:client:jobmenu",
            icon = "fa-solid fa-person",
            onSelect = function ()
                if Job then
                    Notification("Trucking", "You already have a contract! Complete it first to receive another contract!", 8000, "error")
                    return
                end
                lib.showMenu("trucking_jobs_menu")
                
            end
        },
    })

    local blipboss = Config.Boss.blip
    local bossblip = AddBlipForCoord(bossloc.x, bossloc.y, bossloc.z)
    SetBlipSprite(bossblip, blipboss.sprite) 
    SetBlipColour(bossblip, blipboss.color)
    SetBlipScale(bossblip, blipboss.scale)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipboss.text)
    EndTextCommandSetBlipName(bossblip)
    SetBlipAsShortRange(bossblip, true)
end

function CreateBlip(coords, sprite, color, scale, text)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, scale)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    SetBlipAsShortRange(blip, true)

    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 5)
    return blip
end



CreateThread(function ()
    Wait(2000)
    BossNPC()
end)