Config = {}

Config.NotificationType = "ox_lib" -- ox_lib or qbx_core

Config.Ped = {
    model = "cs_josef",
    location = vec4(1197.2439, -3253.5510, 7.0952, 95.4062),
    blip = {
        text = "",
        scale = 1.0,
        sprite = 229,
        color = 2,
    }
}

Config.Job = {
    TruckSpawnLoc = vec4(1189.7308, -3236.5417, 6.0288, 91.9118),
    TruckDelivery = vec3(1202.7256, -3241.0471, 5.96710),
    Contracts = {
        [1] = {
            label = "LS Gas Company",
            truckModel = "phantom",
            trailerModel = "tanker2",
            trailerPickUpLocation = vec4(581.2900, -2310.3435, 5.9083, 84.5083),
            trailerDropLocation = vec3(2674.2952, 1451.5221, 24.5008),
            payment = 10000,
        },
        [2] = {
            label = "Ron Petroleum",
            truckModel = "phantom",
            trailerModel = "tanker",
            trailerPickUpLocation = vec4(1727.3832, -1615.8654, 112.4412, 184.3520),
            trailerDropLocation = vec3(-2535.6289, 2343.5847, 33.0599),
            payment = 12000,
        },
        [3] = {
            label = "Farm",
            truckModel = "hauler",
            trailerModel = "trailers2",
            trailerPickUpLocation = vec4(1828.5789, 4941.4229, 46.0802, 37.1659),
            trailerDropLocation = vec3(-1105.7328, -2407.8770, 13.9452),
            payment = 13000,
        },
        [4] = {
            label = "Dairy",
            truckModel = "hauler",
            trailerModel = "docktrailer",
            trailerPickUpLocation = vec4(2316.0813, 4946.0591, 41.5493, 48.2442),
            trailerDropLocation = vec3(460.3018, -3024.1077, 6.0006),
            payment = 15000,
        },
        [5] = {
            label = "BurgerShot",
            truckModel = "phantom",
            trailerModel = "trailers3",
            trailerPickUpLocation = vec4(9.5647, 6275.0693, 31.2439, 120.8331),
            trailerDropLocation = vec3(-1175.2258, -885.9988, 13.9182),
            payment = 20000,
        },
        [6] = {
            label = "Lumberjack",
            truckModel = "hauler",
            trailerModel = "trailerlogs",
            trailerPickUpLocation = vec4(-602.6614, 5315.8232, 70.4075, 184.9568),
            trailerDropLocation = vec3(-510.0504, -1036.5874, 23.4407),
            payment = 33000,
        },
    }
}