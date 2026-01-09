Config = {}

Config.Locale = 'fr'

-- Paramètres généraux
Config.Debug = false
Config.UseTarget = true -- ox_target
Config.Notification = 'ox_lib' -- ox_lib, esx, custom

-- Temps de farming/transformation (en ms)
Config.FarmingTime = 5000 -- 5 secondes
Config.ProcessingTime = 10000 -- 10 secondes
Config.DistillationTime = 15000 -- 15 secondes

-- Distances d'interaction
Config.DrawDistance = 10.0
Config.InteractDistance = 2.0

-- Items nécessaires
Config.RequiredItems = {
    farming = 'empty_bottle', -- Bouteille vide pour farmer
    tablet = 'alcohol_tablet' -- Tablette pour voir les stats
}

-- Points de farming (levure, eau, sucre, fruits)
Config.FarmingPoints = {
    -- Levure (4 points)
    {
        type = 'levure',
        label = 'Récolte de levure',
        coords = vector3(1929.23, 4873.05, 46.07),
        item = 'levure',
        amount = {min = 1, max = 3},
        requiredItem = 'empty_bottle',
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 49
        }
    },
    {
        type = 'levure',
        label = 'Récolte de levure',
        coords = vector3(1920.87, 4881.74, 46.23),
        item = 'levure',
        amount = {min = 1, max = 3},
        requiredItem = 'empty_bottle',
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 49
        }
    },
    {
        type = 'levure',
        label = 'Récolte de levure',
        coords = vector3(1913.90, 4888.96, 46.56),
        item = 'levure',
        amount = {min = 1, max = 3},
        requiredItem = 'empty_bottle',
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 49
        }
    },
    {
        type = 'levure',
        label = 'Récolte de levure',
        coords = vector3(1909.68, 4892.83, 47.05),
        item = 'levure',
        amount = {min = 1, max = 3},
        requiredItem = 'empty_bottle',
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 49
        }
    },

    -- Eau de source
    {
        type = 'eau',
        label = 'Récolte d\'eau de source',
        coords = vector3(1364.80, 4278.76, 31.0),
        item = 'eau_source',
        amount = {min = 2, max = 5},
        requiredItem = 'empty_bottle',
        animation = {
            dict = 'amb@prop_human_bum_bin@base',
            anim = 'base',
            flag = 49
        }
    },
    {
        type = 'eau',
        label = 'Récolte d\'eau de source',
        coords = vector3(1424.63, 3854.68, 31.00),
        item = 'eau_source',
        amount = {min = 2, max = 5},
        requiredItem = 'empty_bottle',
        animation = {
            dict = 'amb@prop_human_bum_bin@base',
            anim = 'base',
            flag = 49
        }
    },

    -- Sucre
    {
        type = 'sucre',
        label = 'Récolte de canne à sucre',
        coords = vector3(2819.79, -746.01, 15.73),
        item = 'sucre',
        amount = {min = 1, max = 4},
        requiredItem = nil,
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 49
        }
    },
    {
        type = 'sucre',
        label = 'Récolte de canne à sucre',
        coords = vector3(2825.78, -747.19, 16.48),
        item = 'sucre',
        amount = {min = 1, max = 4},
        requiredItem = nil,
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 49
        }
    },

    -- Fruits pour différents alcools
    {
        type = 'raisin',
        label = 'Récolte de raisin',
        coords = vector3(322.28, 6482.87, 29.00),
        item = 'raisin',
        amount = {min = 2, max = 6},
        requiredItem = nil,
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 49
        }
    },
    {
        type = 'pomme',
        label = 'Récolte de pommes',
        coords = vector3(320.89, 6505.91, 29.00),
        item = 'pomme',
        amount = {min = 2, max = 6},
        requiredItem = nil,
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 49
        }
    },
    {
        type = 'mais',
        label = 'Récolte de maïs',
        coords = vector3(272.78, 6455.01, 31.00),
        item = 'mais',
        amount = {min = 2, max = 6},
        requiredItem = nil,
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 49
        }
    },
    {
        type = 'orge',
        label = 'Récolte d\'orge',
        coords = vector3(231.15, 6465.26, 31.00),
        item = 'orge',
        amount = {min = 2, max = 6},
        requiredItem = nil,
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 49
        }
    }
}

-- Laboratoires clandestins (2 labos)
Config.Labs = {
    {
        name = 'Labo #1 - Paleto Bay',
        coords = vector3(1434.54, 6358.43, 24.28),
        blip = {
            enabled = false,
            sprite = 499,
            color = 1,
            scale = 0.8
        }
    },
    {
        name = 'Labo #2 - Sandy Shores',
        coords = vector3(32.23, -626.61, 11.18),
        blip = {
            enabled = false,
            sprite = 499,
            color = 1,
            scale = 0.8
        }
    }
}

-- 9 types d'alcool avec différentes qualités
Config.AlcoholTypes = {
    {
        name = 'Vodka',
        baseItem = 'vodka_base',
        qualities = {
            {quality = 'mauvaise', item = 'vodka_low', sellPrice = 150, ingredients = {levure = 15, eau_source = 15, sucre = 20}},
            {quality = 'moyenne', item = 'vodka_mid', sellPrice = 300, ingredients = {levure = 20, eau_source = 20, sucre = 25}},
            {quality = 'bonne', item = 'vodka_high', sellPrice = 500, ingredients = {levure = 25, eau_source = 25, sucre = 30}}
        },
        distillationTime = 15000
    },
    {
        name = 'Whisky',
        baseItem = 'whisky_base',
        qualities = {
            {quality = 'mauvaise', item = 'whisky_low', sellPrice = 200, ingredients = {levure = 15, orge = 20, eau_source = 15}},
            {quality = 'moyenne', item = 'whisky_mid', sellPrice = 400, ingredients = {levure = 20, orge = 25, eau_source = 20}},
            {quality = 'bonne', item = 'whisky_high', sellPrice = 650, ingredients = {levure = 25, orge = 30, eau_source = 25}}
        },
        distillationTime = 18000
    },
    {
        name = 'Rhum',
        baseItem = 'rhum_base',
        qualities = {
            {quality = 'mauvaise', item = 'rhum_low', sellPrice = 180, ingredients = {levure = 15, sucre = 20, eau_source = 15}},
            {quality = 'moyenne', item = 'rhum_mid', sellPrice = 350, ingredients = {levure = 20, sucre = 25, eau_source = 20}},
            {quality = 'bonne', item = 'rhum_high', sellPrice = 550, ingredients = {levure = 25, sucre = 30, eau_source = 25}}
        },
        distillationTime = 16000
    },
    {
        name = 'Gin',
        baseItem = 'gin_base',
        qualities = {
            {quality = 'mauvaise', item = 'gin_low', sellPrice = 170, ingredients = {levure = 15, orge = 20, eau_source = 15}},
            {quality = 'moyenne', item = 'gin_mid', sellPrice = 320, ingredients = {levure = 20, orge = 25, eau_source = 20}},
            {quality = 'bonne', item = 'gin_high', sellPrice = 520, ingredients = {levure = 25, orge = 30, eau_source = 25}}
        },
        distillationTime = 14000
    },
    {
        name = 'Tequila',
        baseItem = 'tequila_base',
        qualities = {
            {quality = 'mauvaise', item = 'tequila_low', sellPrice = 190, ingredients = {levure = 15, sucre = 20, eau_source = 15}},
            {quality = 'moyenne', item = 'tequila_mid', sellPrice = 370, ingredients = {levure = 20, sucre = 25, eau_source = 20}},
            {quality = 'bonne', item = 'tequila_high', sellPrice = 580, ingredients = {levure = 25, sucre = 30, eau_source = 25}}
        },
        distillationTime = 15000
    },
    {
        name = 'Beer',
        baseItem = 'beer_base',
        qualities = {
            {quality = 'mauvaise', item = 'beer_low', sellPrice = 120, ingredients = {levure = 15, orge = 20, eau_source = 15}},
            {quality = 'moyenne', item = 'beer_mid', sellPrice = 250, ingredients = {levure = 20, orge = 25, eau_source = 20}},
            {quality = 'bonne', item = 'beer_high', sellPrice = 420, ingredients = {levure = 25, orge = 30, eau_source = 25}}
        },
        distillationTime = 12000
    },
    {
        name = 'Moonshine',
        baseItem = 'moonshine_base',
        qualities = {
            {quality = 'mauvaise', item = 'moonshine_low', sellPrice = 220, ingredients = {levure = 15, mais = 20, sucre = 20}},
            {quality = 'moyenne', item = 'moonshine_mid', sellPrice = 450, ingredients = {levure = 20, mais = 25, sucre = 25}},
            {quality = 'bonne', item = 'moonshine_high', sellPrice = 700, ingredients = {levure = 25, mais = 30, sucre = 30}}
        },
        distillationTime = 20000
    },
    {
        name = 'Sake',
        baseItem = 'sake_base',
        qualities = {
            {quality = 'mauvaise', item = 'sake_low', sellPrice = 200, ingredients = {levure = 15, sucre = 20, eau_source = 15}},
            {quality = 'moyenne', item = 'sake_mid', sellPrice = 400, ingredients = {levure = 20, sucre = 25, eau_source = 20}},
            {quality = 'bonne', item = 'sake_high', sellPrice = 650, ingredients = {levure = 25, sucre = 30, eau_source = 25}}
        },
        distillationTime = 16000
    },
    {
        name = 'Cognac',
        baseItem = 'cognac_base',
        qualities = {
            {quality = 'mauvaise', item = 'cognac_low', sellPrice = 280, ingredients = {levure = 15, raisin = 25, eau_source = 15}},
            {quality = 'moyenne', item = 'cognac_mid', sellPrice = 550, ingredients = {levure = 20, raisin = 30, eau_source = 20}},
            {quality = 'bonne', item = 'cognac_high', sellPrice = 900, ingredients = {levure = 25, raisin = 35, eau_source = 25}}
        },
        distillationTime = 25000
    }
}

-- Multiplicateur de prix aléatoire (demande du marché)
Config.PriceMultiplier = {
    min = 0.8,
    max = 1.3
}

-- Expérience gagnée
Config.Experience = {
    farming = 1,
    processing = 5,
    selling = 10
}

-- Système de niveaux pour débloquer des recettes
Config.Levels = {
    {level = 0, name = 'Débutant', recipes = {'Vodka', 'Beer'}},
    {level = 50, name = 'Apprenti', recipes = {'Whisky', 'Gin', 'Rhum'}},
    {level = 150, name = 'Distillateur', recipes = {'Tequila', 'Sake'}},
    {level = 300, name = 'Maître', recipes = {'Moonshine'}},
    {level = 500, name = 'Légende', recipes = {'Cognac'}}
}
