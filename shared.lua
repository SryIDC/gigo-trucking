Config = {}

Config.Boss = {
    ped = "a_m_m_bevhills_02",
    location = vec4(1197.1647, -3251.8413, 7.0952, 92.9338),
    blip = {
        enable = true,
        sprite = 477,
        scale = 1.0,
        color = 1,
        text = "Trucking",
    }
}

Config.NotificationType = "ox_lib" --ox_lib or qbx_core

Config.Job = {
    truckSpawn = vec4(1187.9822, -3239.5693, 6.0288, 87.9874),
    deletetruck = vec3(1202.7256, -3241.0471, 5.96710),
    trailer = {
        [1] = {
            label = "Chicken Coop",
            truck = "hauler",
            trailer = "trailers4",
            pickup = vector4(-15.7612, 6322.5645, 31.2330, 207.5707),
            drop = vec3(-1175.5795, -883.8608, 13.9420),
            payment = math.random(1000, 1700) 
        },
        [2] = {
            label = "Grapeseed Farming",          
            truck = "phantom",    
            trailer = "trailers5",      
            pickup = vector4(2015.4696, 4980.1685, 41.2020, 225.7062), 
            drop = vec3(153.5205, -1456.3374, 29.1415), 
            payment = math.random(1100, 1800) 
        },
        [3] = {
            label = "Lumber",                
            truck = "hauler",     
            trailer = "trailerlogs",
            pickup = vector4(-600.4970, 5300.9268, 70.2144, 246.9123), 
            drop = vec3(1204.8597, -1264.3374, 35.2267), 
            payment = math.random(1200, 1900) 
        },
    }
}