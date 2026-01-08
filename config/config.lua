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
        coords = vector3(1905.14, 4925.43, 48.86),
        item = 'levure',
        amount = {min = 1, max = 3},
        requiredItem = 'empty_bottle',
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 1
        }
    },
    {
        type = 'levure',
        label = 'Récolte de levure',
        coords = vector3(2229.23, 5577.13, 53.85),
        item = 'levure',
        amount = {min = 1, max = 3},
        requiredItem = 'empty_bottle',
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 1
        }
    },
    {
        type = 'levure',
        label = 'Récolte de levure',
        coords = vector3(1392.64, 3606.62, 38.94),
        item = 'levure',
        amount = {min = 1, max = 3},
        requiredItem = 'empty_bottle',
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 1
        }
    },
    {
        type = 'levure',
        label = 'Récolte de levure',
        coords = vector3(2433.93, 4969.18, 46.81),
        item = 'levure',
        amount = {min = 1, max = 3},
        requiredItem = 'empty_bottle',
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 1
        }
    },

    -- Eau de source
    {
        type = 'eau',
        label = 'Récolte d\'eau de source',
        coords = vector3(-1361.29, 4427.94, 35.47),
        item = 'eau_source',
        amount = {min = 2, max = 5},
        requiredItem = 'empty_bottle',
        animation = {
            dict = 'amb@prop_human_bum_bin@base',
            anim = 'base',
            flag = 1
        }
    },
    {
        type = 'eau',
        label = 'Récolte d\'eau de source',
        coords = vector3(1424.13, 6337.52, 23.99),
        item = 'eau_source',
        amount = {min = 2, max = 5},
        requiredItem = 'empty_bottle',
        animation = {
            dict = 'amb@prop_human_bum_bin@base',
            anim = 'base',
            flag = 1
        }
    },

    -- Sucre
    {
        type = 'sucre',
        label = 'Récolte de canne à sucre',
        coords = vector3(2210.37, 5577.81, 53.85),
        item = 'sucre',
        amount = {min = 1, max = 4},
        requiredItem = nil,
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 1
        }
    },
    {
        type = 'sucre',
        label = 'Récolte de canne à sucre',
        coords = vector3(1699.74, 4787.28, 41.92),
        item = 'sucre',
        amount = {min = 1, max = 4},
        requiredItem = nil,
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 1
        }
    },

    -- Fruits pour différents alcools
    {
        type = 'raisin',
        label = 'Récolte de raisin',
        coords = vector3(1989.56, 4951.52, 41.87),
        item = 'raisin',
        amount = {min = 2, max = 6},
        requiredItem = nil,
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 1
        }
    },
    {
        type = 'pomme',
        label = 'Récolte de pommes',
        coords = vector3(361.82, 6495.49, 29.95),
        item = 'pomme',
        amount = {min = 2, max = 6},
        requiredItem = nil,
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 1
        }
    },
    {
        type = 'mais',
        label = 'Récolte de maïs',
        coords = vector3(2238.84, 4797.77, 41.13),
        item = 'mais',
        amount = {min = 2, max = 6},
        requiredItem = nil,
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 1
        }
    },
    {
        type = 'orge',
        label = 'Récolte d\'orge',
        coords = vector3(2852.89, 4704.34, 48.56),
        item = 'orge',
        amount = {min = 2, max = 6},
        requiredItem = nil,
        animation = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            anim = 'weed_inspecting_high_base_inspector',
            flag = 1
        }
    }
}

-- Laboratoires clandestins (2 labos)
Config.Labs = {
    {
        name = 'Labo #1 - Paleto Bay',
        coords = vector3(-131.18, 6366.42, 31.48),
        blip = {
            enabled = false, -- Caché par défaut
            sprite = 499,
            color = 1,
            scale = 0.8
        }
    },
    {
        name = 'Labo #2 - Sandy Shores',
        coords = vector3(1905.69, 4931.72, 48.86),
        blip = {
            enabled = false,
            sprite = 499,
            color = 1,
            scale = 0.8
        }
    }
}

-- Système de vente aux PNJ dans la rue
Config.SellToPeds = {
    enabled = true,
    targetDistance = 2.5, -- Distance pour ox_target
    cooldownBetweenSales = 10000, -- 10 secondes entre chaque vente
    pedCooldown = 60000, -- 1 minute avant de pouvoir revendre au même PNJ

    -- Zones interdites (commissariats, etc.)
    forbiddenZones = {
        {coords = vector3(425.1, -979.5, 30.7), radius = 100.0, name = 'LSPD Mission Row'},
        {coords = vector3(1855.1, 3678.8, 33.8), radius = 80.0, name = 'BCSO Sandy Shores'},
        {coords = vector3(-449.1, 6008.5, 31.7), radius = 80.0, name = 'BCSO Paleto Bay'},
        {coords = vector3(-1093.4, -834.3, 19.0), radius = 50.0, name = 'Vespucci PD'},
    },

    -- Chance de refus selon le type de PNJ (en %)
    refusalChance = {
        default = 30, -- 30% de refus par défaut
        business = 60, -- 60% pour les gens en costard
        gang = 10, -- 10% pour les gangsters
        homeless = 5, -- 5% pour les SDF
    },

    -- Chance d'appel à la police (en %)
    policeCallChance = {
        default = 5, -- 5% de chance d'appeler la police
        business = 15, -- 15% pour les gens en costard
        cop = 100, -- 100% pour les flics
    },

    -- Multiplicateur de prix selon le type de PNJ
    priceMultiplier = {
        default = {min = 0.7, max = 1.0}, -- Prix normal (70% à 100% du prix de base)
        business = {min = 1.0, max = 1.5}, -- Gens riches payent plus (100% à 150%)
        gang = {min = 0.8, max = 1.2}, -- Prix variable
        homeless = {min = 0.4, max = 0.7}, -- SDF payent moins (40% à 70%)
    },

    -- Modèles de PNJ à ignorer (ne peuvent pas acheter)
    blacklistedPeds = {
        's_m_y_cop_01', 's_f_y_cop_01', 's_m_m_snowcop_01',
        's_m_y_sheriff_01', 's_f_y_sheriff_01',
        's_m_y_ranger_01', 's_f_y_ranger_01',
        's_m_m_prisguard_01', 's_m_y_prisguard_01',
        's_m_m_security_01', 's_m_y_armymech_01',
    },

    -- Catégories de PNJ (pour le prix et les chances)
    pedCategories = {
        business = { -- Gens riches/affaires
            'a_m_m_business_01', 'a_m_y_business_01', 'a_m_y_business_02', 'a_m_y_business_03',
            'a_f_m_business_02', 'a_f_y_business_01', 'a_f_y_business_02', 'a_f_y_business_03',
            'a_f_y_business_04', 's_m_m_fiboffice_01', 's_m_m_fiboffice_02'
        },
        gang = { -- Gangsters
            'a_m_y_mexthug_01', 'a_m_y_stbla_01', 'a_m_y_stbla_02', 'a_m_y_stwhi_01', 'a_m_y_stwhi_02',
            'g_m_m_chigoon_01', 'g_m_m_chigoon_02', 'g_m_y_famca_01', 'g_m_y_famdnf_01', 'g_m_y_famfor_01',
            'g_m_y_ballaeast_01', 'g_m_y_ballaorig_01', 'g_m_y_ballasout_01', 'ig_ballasog'
        },
        homeless = { -- SDF
            'a_m_m_tramp_01', 'a_m_m_trampbeac_01', 'a_m_o_tramp_01'
        }
    },

    -- Animations lors de la vente
    animations = {
        player = {
            dict = 'mp_common',
            anim = 'givetake1_a',
            flag = 49
        },
        ped = {
            dict = 'mp_common',
            anim = 'givetake2_a',
            flag = 49
        }
    }
}

-- 10 types d'alcool avec différentes qualités
Config.AlcoholTypes = {
    {
        name = 'Vodka',
        baseItem = 'vodka_base',
        qualities = {
            {quality = 'mauvaise', item = 'vodka_low', sellPrice = 150, ingredients = {levure = 2, eau_source = 3, sucre = 1}},
            {quality = 'moyenne', item = 'vodka_mid', sellPrice = 300, ingredients = {levure = 3, eau_source = 4, sucre = 2}},
            {quality = 'bonne', item = 'vodka_high', sellPrice = 500, ingredients = {levure = 4, eau_source = 5, sucre = 3}}
        },
        distillationTime = 15000
    },
    {
        name = 'Whisky',
        baseItem = 'whisky_base',
        qualities = {
            {quality = 'mauvaise', item = 'whisky_low', sellPrice = 200, ingredients = {levure = 2, orge = 4, eau_source = 2}},
            {quality = 'moyenne', item = 'whisky_mid', sellPrice = 400, ingredients = {levure = 3, orge = 6, eau_source = 3}},
            {quality = 'bonne', item = 'whisky_high', sellPrice = 650, ingredients = {levure = 4, orge = 8, eau_source = 4}}
        },
        distillationTime = 18000
    },
    {
        name = 'Rhum',
        baseItem = 'rhum_base',
        qualities = {
            {quality = 'mauvaise', item = 'rhum_low', sellPrice = 180, ingredients = {levure = 2, sucre = 5, eau_source = 2}},
            {quality = 'moyenne', item = 'rhum_mid', sellPrice = 350, ingredients = {levure = 3, sucre = 7, eau_source = 3}},
            {quality = 'bonne', item = 'rhum_high', sellPrice = 550, ingredients = {levure = 4, sucre = 10, eau_source = 4}}
        },
        distillationTime = 16000
    },
    {
        name = 'Gin',
        baseItem = 'gin_base',
        qualities = {
            {quality = 'mauvaise', item = 'gin_low', sellPrice = 170, ingredients = {levure = 2, orge = 3, eau_source = 3}},
            {quality = 'moyenne', item = 'gin_mid', sellPrice = 320, ingredients = {levure = 3, orge = 5, eau_source = 4}},
            {quality = 'bonne', item = 'gin_high', sellPrice = 520, ingredients = {levure = 4, orge = 7, eau_source = 5}}
        },
        distillationTime = 14000
    },
    {
        name = 'Tequila',
        baseItem = 'tequila_base',
        qualities = {
            {quality = 'mauvaise', item = 'tequila_low', sellPrice = 190, ingredients = {levure = 2, sucre = 4, eau_source = 2}},
            {quality = 'moyenne', item = 'tequila_mid', sellPrice = 370, ingredients = {levure = 3, sucre = 6, eau_source = 3}},
            {quality = 'bonne', item = 'tequila_high', sellPrice = 580, ingredients = {levure = 4, sucre = 8, eau_source = 4}}
        },
        distillationTime = 15000
    },
    {
        name = 'Calvados',
        baseItem = 'calvados_base',
        qualities = {
            {quality = 'mauvaise', item = 'calvados_low', sellPrice = 160, ingredients = {levure = 2, pomme = 6, eau_source = 2}},
            {quality = 'moyenne', item = 'calvados_mid', sellPrice = 310, ingredients = {levure = 3, pomme = 9, eau_source = 3}},
            {quality = 'bonne', item = 'calvados_high', sellPrice = 510, ingredients = {levure = 4, pomme = 12, eau_source = 4}}
        },
        distillationTime = 17000
    },
    {
        name = 'Moonshine',
        baseItem = 'moonshine_base',
        qualities = {
            {quality = 'mauvaise', item = 'moonshine_low', sellPrice = 220, ingredients = {levure = 3, mais = 5, sucre = 3}},
            {quality = 'moyenne', item = 'moonshine_mid', sellPrice = 450, ingredients = {levure = 4, mais = 7, sucre = 4}},
            {quality = 'bonne', item = 'moonshine_high', sellPrice = 700, ingredients = {levure = 5, mais = 10, sucre = 5}}
        },
        distillationTime = 20000
    },
    {
        name = 'Absinthe',
        baseItem = 'absinthe_base',
        qualities = {
            {quality = 'mauvaise', item = 'absinthe_low', sellPrice = 250, ingredients = {levure = 3, orge = 4, sucre = 4}},
            {quality = 'moyenne', item = 'absinthe_mid', sellPrice = 500, ingredients = {levure = 4, orge = 6, sucre = 6}},
            {quality = 'bonne', item = 'absinthe_high', sellPrice = 800, ingredients = {levure = 5, orge = 8, sucre = 8}}
        },
        distillationTime = 22000
    },
    {
        name = 'Cognac',
        baseItem = 'cognac_base',
        qualities = {
            {quality = 'mauvaise', item = 'cognac_low', sellPrice = 280, ingredients = {levure = 3, raisin = 8, eau_source = 3}},
            {quality = 'moyenne', item = 'cognac_mid', sellPrice = 550, ingredients = {levure = 4, raisin = 12, eau_source = 4}},
            {quality = 'bonne', item = 'cognac_high', sellPrice = 900, ingredients = {levure = 5, raisin = 16, eau_source = 5}}
        },
        distillationTime = 25000
    },
    {
        name = 'Pastis',
        baseItem = 'pastis_base',
        qualities = {
            {quality = 'mauvaise', item = 'pastis_low', sellPrice = 140, ingredients = {levure = 2, sucre = 3, eau_source = 4}},
            {quality = 'moyenne', item = 'pastis_mid', sellPrice = 280, ingredients = {levure = 3, sucre = 4, eau_source = 6}},
            {quality = 'bonne', item = 'pastis_high', sellPrice = 450, ingredients = {levure = 4, sucre = 6, eau_source = 8}}
        },
        distillationTime = 13000
    }
}

-- Multiplicateur de prix aléatoire (demande du marché)
Config.PriceMultiplier = {
    min = 0.8, -- -20%
    max = 1.3  -- +30%
}

-- Expérience gagnée
Config.Experience = {
    farming = 1,
    processing = 5,
    selling = 10
}

-- Système de niveaux pour débloquer des recettes
Config.Levels = {
    {level = 0, name = 'Débutant', recipes = {'Vodka', 'Pastis'}},
    {level = 50, name = 'Apprenti', recipes = {'Whisky', 'Gin', 'Rhum'}},
    {level = 150, name = 'Distillateur', recipes = {'Tequila', 'Calvados'}},
    {level = 300, name = 'Maître', recipes = {'Moonshine', 'Absinthe'}},
    {level = 500, name = 'Légende', recipes = {'Cognac'}}
}
