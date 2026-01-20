Config = {}

-- =============================================================================
-- CONFIGURATION GENERALE
-- =============================================================================

Config.Debug = true -- Mettre false en production
Config.UseOxTarget = true -- Utiliser ox_target ou touches clavier
Config.DrawDistance = 15.0 -- Distance d'affichage 3D UI
Config.InteractDistance = 2.5 -- Distance d'interaction

-- Couleurs 3D UI
Config.Colors = {
    primary = {102, 126, 234},    -- Bleu
    success = {46, 204, 113},     -- Vert
    error = {255, 107, 107},      -- Rouge
    warning = {247, 183, 49},     -- Jaune
    illegal = {148, 0, 211},      -- Violet (missions illegales)
    background = {30, 30, 46},    -- Fond sombre
    white = {255, 255, 255},      -- Blanc
}

-- =============================================================================
-- SYSTEME DE NIVEAUX PAR JOB
-- =============================================================================

Config.Levels = {
    {xp = 0,    name = 'Debutant',    bonus = 1.0},
    {xp = 100,  name = 'Apprenti',    bonus = 1.1},
    {xp = 300,  name = 'Confirme',    bonus = 1.25},
    {xp = 600,  name = 'Expert',      bonus = 1.4},
    {xp = 1000, name = 'Maitre',      bonus = 1.6},
}

-- =============================================================================
-- SYSTEME MISSIONS ILLEGALES
-- =============================================================================

Config.IllegalMissions = {
    enabled = true,
    checkInterval = 300000, -- Verifier toutes les 5 minutes (ms)
    chance = 15, -- 15% de chance qu'une mission pop
    decisionTime = 30000, -- 30 secondes pour accepter/refuser
    policeAlertChance = 10, -- 10% de chance d'alerte police
    cooldown = 600000, -- 10 minutes entre chaque mission possible
}

-- =============================================================================
-- JOB 1: MINEUR
-- =============================================================================

Config.Jobs = {}

Config.Jobs['mineur'] = {
    label = 'Mineur',
    blip = {
        sprite = 618,
        color = 40,
        scale = 0.5,
        label = 'Mine'
    },
    xpPerAction = 2,
    requiredItem = 'pickaxe', -- Outil requis pour miner

    startPoint = vector3(2959.54, 2774.36, 39.31),

    -- Points de farm avec les nouveaux items
    farmPoints = {
        -- Zone charbon/silex (debutant)
        {coords = vector3(2950.12, 2780.45, 39.31), label = 'Veine de charbon', item = 'coal_ore', minAmount = 1, maxAmount = 3, time = 6000},
        {coords = vector3(2962.34, 2769.12, 39.31), label = 'Roche de silex', item = 'flint', minAmount = 1, maxAmount = 2, time = 5000},
        {coords = vector3(2944.67, 2788.23, 39.31), label = 'Depot de soufre', item = 'sulfur_chunk', minAmount = 1, maxAmount = 2, time = 7000},

        -- Zone or (intermediaire)
        {coords = vector3(2970.89, 2762.56, 39.31), label = 'Veine d\'or', item = 'gold_nugget', minAmount = 1, maxAmount = 1, time = 10000},
        {coords = vector3(2938.45, 2795.78, 39.31), label = 'Sable aurifere', item = 'gold_dust', minAmount = 1, maxAmount = 2, time = 8000},

        -- Zone cristaux (avance)
        {coords = vector3(2978.12, 2755.34, 39.31), label = 'Cristal de quartz', item = 'quartz_crystal', minAmount = 1, maxAmount = 1, time = 12000},
        {coords = vector3(2932.56, 2802.12, 39.31), label = 'Emeraude brute', item = 'emerald_crystal', minAmount = 1, maxAmount = 1, time = 15000},
        {coords = vector3(2985.34, 2748.67, 39.31), label = 'Beryl brut', item = 'beryl_chunk', minAmount = 1, maxAmount = 1, time = 12000},
        {coords = vector3(2925.78, 2808.45, 39.31), label = 'Grenat vert', item = 'green_garnet', minAmount = 1, maxAmount = 1, time = 10000},

        -- Zone rubis/saphir (expert)
        {coords = vector3(2992.12, 2741.23, 39.31), label = 'Rubis brut', item = 'ruby_crystal', minAmount = 1, maxAmount = 1, time = 18000},
        {coords = vector3(2918.45, 2815.67, 39.31), label = 'Corindon', item = 'corundum_chunk', minAmount = 1, maxAmount = 1, time = 14000},
        {coords = vector3(2998.67, 2735.89, 39.31), label = 'Saphir rose', item = 'pink_sapphire', minAmount = 1, maxAmount = 1, time = 16000},

        -- Zone amethyste/diamant (maitre)
        {coords = vector3(2912.23, 2822.34, 39.31), label = 'Geode d\'amethyste', item = 'amethyst_geode', minAmount = 1, maxAmount = 1, time = 20000},
        {coords = vector3(3005.45, 2728.56, 39.31), label = 'Quartz violet', item = 'purple_quartz', minAmount = 1, maxAmount = 1, time = 15000},
        {coords = vector3(2905.67, 2828.78, 39.31), label = 'Cristal pur', item = 'clear_crystal', minAmount = 1, maxAmount = 1, time = 18000},
        {coords = vector3(3012.89, 2722.12, 39.31), label = 'Diamant brut', item = 'diamond_crystal', minAmount = 1, maxAmount = 1, time = 25000},
        {coords = vector3(2898.12, 2835.45, 39.31), label = 'Graphite', item = 'graphite_chunk', minAmount = 1, maxAmount = 2, time = 12000},
        {coords = vector3(3018.34, 2715.67, 39.31), label = 'Diamant bleu', item = 'blue_diamond', minAmount = 1, maxAmount = 1, time = 30000},
    },

    sellPoint = {
        coords = vector3(2930.45, 2800.12, 39.31),
        label = 'Vendre minerais',
        prices = {
            ['coal_ore'] = 15,
            ['flint'] = 12,
            ['sulfur_chunk'] = 18,
            ['gold_nugget'] = 85,
            ['gold_dust'] = 45,
            ['quartz_crystal'] = 55,
            ['emerald_crystal'] = 180,
            ['beryl_chunk'] = 65,
            ['green_garnet'] = 95,
            ['ruby_crystal'] = 250,
            ['corundum_chunk'] = 75,
            ['pink_sapphire'] = 220,
            ['amethyst_geode'] = 150,
            ['purple_quartz'] = 85,
            ['clear_crystal'] = 120,
            ['diamond_crystal'] = 450,
            ['graphite_chunk'] = 35,
            ['blue_diamond'] = 650,
        }
    },

    animation = {
        dict = 'amb@world_human_hammering@male@base',
        anim = 'base',
        flag = 49
    },

    prop = {
        model = 'prop_tool_pickaxe',
        bone = 28422,
        offset = vector3(0.0, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 0.0)
    },

    -- Missions illegales pour ce job
    illegalMissions = {
        {
            id = 'mine_undeclared',
            label = 'Extraction non declaree',
            description = 'Un type veut des minerais sans trace...',
            targetItem = 'gold_nugget',
            targetAmount = 3,
            reward = 800, -- Argent sale
            time = 120000, -- 2 minutes pour completer
            xpBonus = 25,
        },
        {
            id = 'mine_steal_gems',
            label = 'Vol de pierres precieuses',
            description = 'Recupere des gemmes pour un receleur...',
            targetItem = 'emerald_crystal',
            targetAmount = 2,
            reward = 1200,
            time = 180000,
            xpBonus = 40,
        },
        {
            id = 'mine_black_diamonds',
            label = 'Diamants au noir',
            description = 'Des diamants qui n\'existent pas officiellement...',
            targetItem = 'diamond_crystal',
            targetAmount = 1,
            reward = 2000,
            time = 240000,
            xpBonus = 60,
        },
    },
}

-- =============================================================================
-- JOB 2: BUCHERON
-- =============================================================================

Config.Jobs['bucheron'] = {
    label = 'Bucheron',
    blip = {
        sprite = 77,
        color = 25,
        scale = 0.5,
        label = 'Scierie'
    },
    xpPerAction = 2,
    requiredItem = nil, -- On check les haches dans le code
    requiredAxes = {'axe_rusty', 'axe_iron', 'axe_mythical'}, -- Une de ces haches requise

    startPoint = vector3(-537.09, 5252.53, 74.17),

    farmPoints = {
        {coords = vector3(-550.23, 5245.67, 74.17), label = 'Arbre a abattre', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(-525.45, 5260.89, 74.17), label = 'Arbre a abattre', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(-560.78, 5238.12, 74.17), label = 'Arbre a abattre', item = 'wood_log', minAmount = 3, maxAmount = 5, time = 14000},
        {coords = vector3(-515.34, 5268.45, 74.17), label = 'Arbre a abattre', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(-545.67, 5255.23, 74.17), label = 'Arbre a abattre', item = 'wood_log', minAmount = 2, maxAmount = 5, time = 13000},
        {coords = vector3(-532.12, 5248.78, 74.17), label = 'Arbre a abattre', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(-570.45, 5230.56, 74.17), label = 'Gros arbre', item = 'wood_log', minAmount = 4, maxAmount = 6, time = 18000},
        {coords = vector3(-505.67, 5275.34, 74.17), label = 'Arbre a abattre', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
    },

    sellPoint = {
        coords = vector3(-580.45, 5220.12, 74.17),
        label = 'Vendre bois',
        prices = {
            ['wood_log'] = 18,
        }
    },

    animation = {
        dict = 'melee@large_wpn@streamed_core',
        anim = 'ground_attack_on_spot',
        flag = 1
    },

    prop = {
        model = 'prop_tool_fireaxe',
        bone = 28422,
        offset = vector3(0.0, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 0.0)
    },

    illegalMissions = {
        {
            id = 'lumber_protected',
            label = 'Arbres proteges',
            description = 'Abattre des arbres classes illegalement...',
            targetItem = 'wood_log',
            targetAmount = 8,
            reward = 600,
            time = 180000,
            xpBonus = 30,
        },
        {
            id = 'lumber_black_market',
            label = 'Bois au marche noir',
            description = 'Du bois rare pour un acheteur discret...',
            targetItem = 'wood_log',
            targetAmount = 15,
            reward = 1100,
            time = 240000,
            xpBonus = 45,
        },
    },
}

-- =============================================================================
-- JOB 3: BOUCHER
-- =============================================================================

Config.Jobs['boucher'] = {
    label = 'Boucher',
    blip = {
        sprite = 141,
        color = 1,
        scale = 0.5,
        label = 'Abattoir'
    },
    xpPerAction = 3,

    startPoint = vector3(967.12, -2150.45, 30.51),

    farmPoints = {
        {coords = vector3(975.34, -2145.67, 30.51), label = 'Depecer boeuf', item = 'meat_beef', minAmount = 3, maxAmount = 6, time = 15000},
        {coords = vector3(960.45, -2155.89, 30.51), label = 'Depecer porc', item = 'meat_pork', minAmount = 2, maxAmount = 5, time = 12000},
        {coords = vector3(980.67, -2138.12, 30.51), label = 'Depecer poulet', item = 'meat_chicken', minAmount = 4, maxAmount = 8, time = 8000},
        {coords = vector3(952.89, -2162.34, 30.51), label = 'Recuperer cuir', item = 'raw_leather', minAmount = 1, maxAmount = 3, time = 10000},
        {coords = vector3(988.12, -2130.56, 30.51), label = 'Depecer agneau', item = 'meat_lamb', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(945.34, -2168.78, 30.51), label = 'Recuperer cuir', item = 'raw_leather', minAmount = 2, maxAmount = 4, time = 10000},
    },

    sellPoint = {
        coords = vector3(940.12, -2175.45, 30.51),
        label = 'Vendre viande',
        prices = {
            ['meat_beef'] = 28,
            ['meat_pork'] = 22,
            ['meat_chicken'] = 15,
            ['meat_lamb'] = 32,
            ['raw_leather'] = 45,
        }
    },

    animation = {
        dict = 'anim@amb@business@coc@coc_packing_cut@',
        anim = 'fullcut_cycle_v1_cokecutter',
        flag = 49
    },

    prop = {
        model = 'prop_cs_cleaver',
        bone = 28422,
        offset = vector3(0.0, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 0.0)
    },

    illegalMissions = {
        {
            id = 'butcher_expired',
            label = 'Viande perimee',
            description = 'Ecouler de la viande douteuse au black...',
            targetItem = 'meat_beef',
            targetAmount = 5,
            reward = 500,
            time = 150000,
            xpBonus = 25,
        },
        {
            id = 'butcher_untraceable',
            label = 'Viande non tracee',
            description = 'De la viande sans controle sanitaire...',
            targetItem = 'meat_pork',
            targetAmount = 8,
            reward = 750,
            time = 180000,
            xpBonus = 35,
        },
    },
}

-- =============================================================================
-- JOB 4: LIVREUR PIZZA
-- =============================================================================

Config.Jobs['livreur_pizza'] = {
    label = 'Livreur Pizza',
    blip = {
        sprite = 93,
        color = 47,
        scale = 0.5,
        label = 'Pizzeria'
    },
    xpPerAction = 3,

    startPoint = vector3(540.12, 100.45, 96.53),

    deliveryPickup = {
        coords = vector3(540.12, 100.45, 96.53),
        label = 'Recuperer commandes',
    },

    deliveryPoints = {
        {coords = vector3(195.34, -935.67, 30.69), label = 'Livrer pizza', reward = 85, time = 5000},
        {coords = vector3(-265.45, -965.89, 31.22), label = 'Livrer pizza', reward = 95, time = 5000},
        {coords = vector3(425.67, -808.12, 29.49), label = 'Livrer pizza', reward = 75, time = 5000},
        {coords = vector3(-45.89, -585.34, 38.83), label = 'Livrer pizza', reward = 105, time = 5000},
        {coords = vector3(310.12, -280.56, 54.16), label = 'Livrer pizza', reward = 120, time = 5000},
        {coords = vector3(-710.34, -915.78, 19.21), label = 'Livrer pizza', reward = 90, time = 5000},
        {coords = vector3(145.56, -1035.12, 29.34), label = 'Livrer pizza', reward = 80, time = 5000},
        {coords = vector3(-1220.78, -335.45, 37.78), label = 'Livrer pizza', reward = 135, time = 5000},
    },

    vehicle = {
        model = 'faggio',
        spawnPoint = vector4(542.34, 98.67, 96.53, 160.0),
    },

    animation = {
        dict = 'mp_common',
        anim = 'givetake1_a',
        flag = 49
    },

    bonusTime = 120,
    bonusAmount = 50,

    illegalMissions = {
        {
            id = 'pizza_shady_delivery',
            label = 'Livraison douteuse',
            description = 'Un colis a livrer discretement, pas de questions...',
            targetCoords = vector3(-1550.45, -450.67, 40.52),
            reward = 900,
            time = 180000,
            xpBonus = 35,
        },
        {
            id = 'pizza_cash_pickup',
            label = 'Recuperation express',
            description = 'Recuperer une enveloppe pour quelqu\'un...',
            targetCoords = vector3(150.23, -1050.45, 29.34),
            reward = 700,
            time = 150000,
            xpBonus = 30,
        },
    },
}

-- =============================================================================
-- JOB 5: EBOUEUR
-- =============================================================================

Config.Jobs['eboueur'] = {
    label = 'Eboueur',
    blip = {
        sprite = 318,
        color = 69,
        scale = 0.5,
        label = 'Depot Eboueurs'
    },
    xpPerAction = 2,

    startPoint = vector3(-322.45, -1545.67, 27.53),

    collectPoints = {
        {coords = vector3(-245.34, -1510.67, 30.53), label = 'Ramasser poubelle', time = 4000},
        {coords = vector3(-198.45, -1485.89, 31.22), label = 'Ramasser poubelle', time = 4000},
        {coords = vector3(-156.67, -1520.12, 32.45), label = 'Ramasser poubelle', time = 4000},
        {coords = vector3(-285.89, -1580.34, 29.67), label = 'Ramasser poubelle', time = 4000},
        {coords = vector3(-310.12, -1605.56, 28.89), label = 'Ramasser poubelle', time = 4000},
        {coords = vector3(-178.34, -1550.78, 33.12), label = 'Ramasser poubelle', time = 4000},
        {coords = vector3(-225.56, -1475.12, 31.78), label = 'Ramasser poubelle', time = 4000},
        {coords = vector3(-265.78, -1545.45, 30.34), label = 'Ramasser poubelle', time = 4000},
    },

    depositPoint = {
        coords = vector3(-350.12, -1560.45, 25.23),
        label = 'Deposer dechets',
        rewardPerBag = 25,
    },

    vehicle = {
        model = 'trash',
        spawnPoint = vector4(-325.34, -1550.67, 27.53, 270.0),
    },

    animation = {
        dict = 'anim@move_m@trash',
        anim = 'pickup',
        flag = 49
    },

    illegalMissions = {
        {
            id = 'trash_hidden_package',
            label = 'Colis cache',
            description = 'Un paquet d\'argent planque dans une poubelle...',
            targetCoords = vector3(-280.45, -1560.78, 30.12),
            reward = 850,
            time = 120000,
            xpBonus = 30,
        },
        {
            id = 'trash_dispose_evidence',
            label = 'Disparition discrete',
            description = 'Faire disparaitre un sac compromettant...',
            targetCoords = vector3(-195.67, -1500.23, 31.45),
            reward = 1100,
            time = 150000,
            xpBonus = 40,
        },
    },
}

-- =============================================================================
-- JOB 6: FACTEUR
-- =============================================================================

Config.Jobs['facteur'] = {
    label = 'Facteur',
    blip = {
        sprite = 478,
        color = 38,
        scale = 0.5,
        label = 'Bureau de Poste'
    },
    xpPerAction = 2,

    startPoint = vector3(105.45, -1568.67, 29.60),

    deliveryPickup = {
        coords = vector3(105.45, -1568.67, 29.60),
        label = 'Recuperer colis',
    },

    deliveryPoints = {
        {coords = vector3(-125.34, -1525.67, 34.12), label = 'Livrer colis', reward = 45, time = 3000},
        {coords = vector3(85.45, -1610.89, 29.45), label = 'Livrer colis', reward = 40, time = 3000},
        {coords = vector3(215.67, -1545.12, 29.34), label = 'Livrer colis', reward = 50, time = 3000},
        {coords = vector3(-45.89, -1480.34, 31.56), label = 'Livrer colis', reward = 55, time = 3000},
        {coords = vector3(165.12, -1495.56, 29.78), label = 'Livrer colis', reward = 42, time = 3000},
        {coords = vector3(25.34, -1545.78, 29.23), label = 'Livrer colis', reward = 38, time = 3000},
        {coords = vector3(-85.56, -1590.12, 30.67), label = 'Livrer colis', reward = 48, time = 3000},
        {coords = vector3(135.78, -1620.45, 29.12), label = 'Livrer colis', reward = 44, time = 3000},
        {coords = vector3(-165.12, -1455.67, 32.89), label = 'Livrer colis', reward = 60, time = 3000},
        {coords = vector3(245.34, -1580.89, 29.56), label = 'Livrer colis', reward = 52, time = 3000},
    },

    vehicle = {
        model = 'boxville2',
        spawnPoint = vector4(108.34, -1572.67, 29.60, 230.0),
    },

    animation = {
        dict = 'mp_common',
        anim = 'givetake1_a',
        flag = 49
    },

    illegalMissions = {
        {
            id = 'mail_intercept_cash',
            label = 'Interception',
            description = 'Une enveloppe pleine de cash a intercepter...',
            targetCoords = vector3(-150.34, -1510.67, 33.45),
            reward = 950,
            time = 120000,
            xpBonus = 35,
        },
        {
            id = 'mail_secret_delivery',
            label = 'Livraison secrete',
            description = 'Un colis tres discret a deposer...',
            targetCoords = vector3(200.45, -1560.23, 29.78),
            reward = 750,
            time = 150000,
            xpBonus = 30,
        },
    },
}

-- =============================================================================
-- JOB 7: AGENT D'ENTRETIEN
-- =============================================================================

Config.Jobs['agent_entretien'] = {
    label = 'Agent d\'entretien',
    blip = {
        sprite = 556,
        color = 26,
        scale = 0.5,
        label = 'Societe Nettoyage'
    },
    xpPerAction = 2,

    startPoint = vector3(-1395.67, -480.34, 72.04),

    cleanPoints = {
        {coords = vector3(-1380.34, -475.67, 72.04), label = 'Nettoyer sol', time = 6000, reward = 35},
        {coords = vector3(-1405.45, -490.89, 72.04), label = 'Nettoyer vitres', time = 8000, reward = 45},
        {coords = vector3(-1365.67, -465.12, 72.04), label = 'Nettoyer sol', time = 6000, reward = 35},
        {coords = vector3(-1420.89, -505.34, 72.04), label = 'Vider poubelles', time = 4000, reward = 25},
        {coords = vector3(-1350.12, -455.56, 72.04), label = 'Nettoyer toilettes', time = 10000, reward = 60},
        {coords = vector3(-1435.34, -520.78, 72.04), label = 'Nettoyer sol', time = 6000, reward = 35},
        {coords = vector3(-1375.56, -485.12, 72.04), label = 'Nettoyer vitres', time = 8000, reward = 45},
        {coords = vector3(-1410.78, -500.45, 72.04), label = 'Vider poubelles', time = 4000, reward = 25},
    },

    animation = {
        dict = 'amb@world_human_maid_clean@',
        anim = 'base',
        flag = 49
    },

    prop = {
        model = 'prop_mop_02',
        bone = 28422,
        offset = vector3(0.0, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 0.0)
    },

    illegalMissions = {
        {
            id = 'clean_office_theft',
            label = 'Fouille discrete',
            description = 'Fouiller les bureaux et recuperer du cash...',
            targetCoords = vector3(-1390.45, -480.67, 72.04),
            reward = 800,
            time = 120000,
            xpBonus = 30,
        },
        {
            id = 'clean_safe_crack',
            label = 'Coffre oublie',
            description = 'Un petit coffre mal ferme dans un bureau...',
            targetCoords = vector3(-1360.23, -460.45, 72.04),
            reward = 1500,
            time = 180000,
            xpBonus = 50,
        },
    },
}

-- =============================================================================
-- JOB 8: JARDINIER
-- =============================================================================

Config.Jobs['jardinier'] = {
    label = 'Jardinier Municipal',
    blip = {
        sprite = 808,
        color = 25,
        scale = 0.5,
        label = 'Services Espaces Verts'
    },
    xpPerAction = 2,

    startPoint = vector3(-1222.45, -1475.67, 4.36),

    gardenPoints = {
        {coords = vector3(-1235.34, -1465.67, 4.36), label = 'Tondre pelouse', time = 10000, reward = 55, type = 'tondre'},
        {coords = vector3(-1210.45, -1485.89, 4.36), label = 'Tailler haie', time = 8000, reward = 45, type = 'tailler'},
        {coords = vector3(-1250.67, -1455.12, 4.36), label = 'Arroser fleurs', time = 5000, reward = 30, type = 'arroser'},
        {coords = vector3(-1195.89, -1495.34, 4.36), label = 'Ramasser feuilles', time = 6000, reward = 35, type = 'ramasser'},
        {coords = vector3(-1265.12, -1445.56, 4.36), label = 'Tondre pelouse', time = 10000, reward = 55, type = 'tondre'},
        {coords = vector3(-1180.34, -1505.78, 4.36), label = 'Tailler haie', time = 8000, reward = 45, type = 'tailler'},
        {coords = vector3(-1240.56, -1475.12, 4.36), label = 'Arroser fleurs', time = 5000, reward = 30, type = 'arroser'},
        {coords = vector3(-1205.78, -1490.45, 4.36), label = 'Planter fleurs', time = 12000, reward = 65, type = 'planter'},
    },

    animation = {
        tondre = {dict = 'amb@world_human_gardener_plant@male@base', anim = 'base', flag = 49},
        tailler = {dict = 'melee@large_wpn@streamed_core', anim = 'ground_attack_on_spot', flag = 1},
        arroser = {dict = 'amb@world_human_gardener_plant@male@base', anim = 'base', flag = 49},
        ramasser = {dict = 'anim@move_m@trash', anim = 'pickup', flag = 49},
        planter = {dict = 'amb@world_human_gardener_plant@male@base', anim = 'base', flag = 49},
    },

    prop = {
        model = 'prop_tool_shovel',
        bone = 28422,
        offset = vector3(0.0, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 0.0)
    },

    illegalMissions = {
        {
            id = 'garden_bury_cash',
            label = 'Enterrer le magot',
            description = 'Enterrer un sac d\'argent dans le parc...',
            targetCoords = vector3(-1230.45, -1470.67, 4.36),
            reward = 700,
            time = 120000,
            xpBonus = 25,
        },
        {
            id = 'garden_dig_stash',
            label = 'Deterrer la planque',
            description = 'Recuperer un colis enterre par quelqu\'un...',
            targetCoords = vector3(-1200.23, -1490.45, 4.36),
            reward = 1200,
            time = 150000,
            xpBonus = 45,
        },
    },
}
