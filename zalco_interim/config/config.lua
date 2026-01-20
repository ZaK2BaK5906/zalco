Config = {}

-- =============================================================================
-- CONFIGURATION GENERALE
-- =============================================================================

Config.Debug = true
Config.DrawDistance = 10.0
Config.InteractDistance = 2.5
Config.FarmCooldown = 120000 -- 2 minutes

Config.UI = {
    promptOffset = 0.65,
    progressBarOffset = 0.35,
    cooldownOffset = 0.55,
    maxVisiblePrompts = 1,
}

Config.Colors = {
    primary = {102, 126, 234},
    success = {46, 204, 113},
    error = {255, 107, 107},
    warning = {247, 183, 49},
    illegal = {148, 0, 211},
    background = {30, 30, 46},
    white = {255, 255, 255},
}

-- =============================================================================
-- SYSTEME DE NIVEAUX
-- =============================================================================

Config.Levels = {
    {xp = 0,    name = 'Debutant',    bonus = 1.0},
    {xp = 100,  name = 'Apprenti',    bonus = 1.1},
    {xp = 300,  name = 'Confirme',    bonus = 1.25},
    {xp = 600,  name = 'Expert',      bonus = 1.4},
    {xp = 1000, name = 'Maitre',      bonus = 1.6},
}

-- =============================================================================
-- MISSIONS ILLEGALES CONFIG
-- =============================================================================

Config.IllegalMissions = {
    enabled = true,
    checkInterval = 300000,
    chance = 15,
    decisionTime = 30000,
    policeAlertChance = 10,
    cooldown = 600000,
}

-- =============================================================================
-- JOBS
-- =============================================================================

Config.Jobs = {}

-- =============================================================================
-- JOB 1: MINEUR
-- =============================================================================

Config.Jobs['mineur'] = {
    label = 'Mineur',
    blip = {sprite = 618, color = 40, scale = 0.5, label = 'Mine'},
    xpPerAction = 2,
    requiredItem = 'pickaxe',

    -- NPC Service (prendre/arreter job + stats)
    npcService = {
        model = 's_m_y_construct_01',
        coords = vector4(2959.54, 2774.36, 39.31, 180.0),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        label = 'Chef de chantier',
    },

    -- NPC Shop (acheter outils)
    npcShop = {
        model = 's_m_m_lathandy_01',
        coords = vector4(2955.12, 2778.45, 39.31, 220.0),
        scenario = 'WORLD_HUMAN_STAND_IMPATIENT',
        label = 'Vendeur outils',
        items = {
            {item = 'pickaxe', price = 500, label = 'Pioche'},
        }
    },

    -- NPC Vente (revendre items)
    npcSell = {
        model = 'a_m_m_business_01',
        coords = vector4(2930.45, 2800.12, 39.31, 90.0),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        label = 'Acheteur minerais',
        prices = {
            ['coal_ore'] = 15, ['flint'] = 12, ['sulfur_chunk'] = 18,
            ['gold_nugget'] = 85, ['gold_dust'] = 45, ['quartz_crystal'] = 55,
            ['emerald_crystal'] = 180, ['beryl_chunk'] = 65, ['green_garnet'] = 95,
            ['ruby_crystal'] = 250, ['corundum_chunk'] = 75, ['pink_sapphire'] = 220,
            ['amethyst_geode'] = 150, ['purple_quartz'] = 85, ['clear_crystal'] = 120,
            ['diamond_crystal'] = 450, ['graphite_chunk'] = 35, ['blue_diamond'] = 650,
        }
    },

    startPoint = vector3(2959.54, 2774.36, 39.31),

    farmPoints = {
        {coords = vector3(2950.12, 2780.45, 39.31), label = 'Veine de charbon', item = 'coal_ore', minAmount = 1, maxAmount = 3, time = 6000},
        {coords = vector3(2962.34, 2769.12, 39.31), label = 'Roche de silex', item = 'flint', minAmount = 1, maxAmount = 2, time = 5000},
        {coords = vector3(2944.67, 2788.23, 39.31), label = 'Depot de soufre', item = 'sulfur_chunk', minAmount = 1, maxAmount = 2, time = 7000},
        {coords = vector3(2970.89, 2762.56, 39.31), label = 'Veine d\'or', item = 'gold_nugget', minAmount = 1, maxAmount = 1, time = 10000},
        {coords = vector3(2938.45, 2795.78, 39.31), label = 'Sable aurifere', item = 'gold_dust', minAmount = 1, maxAmount = 2, time = 8000},
        {coords = vector3(2978.12, 2755.34, 39.31), label = 'Cristal de quartz', item = 'quartz_crystal', minAmount = 1, maxAmount = 1, time = 12000},
        {coords = vector3(2932.56, 2802.12, 39.31), label = 'Emeraude brute', item = 'emerald_crystal', minAmount = 1, maxAmount = 1, time = 15000},
        {coords = vector3(2985.34, 2748.67, 39.31), label = 'Rubis brut', item = 'ruby_crystal', minAmount = 1, maxAmount = 1, time = 18000},
        {coords = vector3(2912.23, 2822.34, 39.31), label = 'Geode amethyste', item = 'amethyst_geode', minAmount = 1, maxAmount = 1, time = 20000},
        {coords = vector3(3005.45, 2728.56, 39.31), label = 'Diamant brut', item = 'diamond_crystal', minAmount = 1, maxAmount = 1, time = 25000},
    },

    animation = {dict = 'amb@world_human_hammering@male@base', anim = 'base', flag = 49},
    prop = {model = 'prop_tool_pickaxe', bone = 28422, offset = vector3(0,0,0), rotation = vector3(0,0,0)},

    illegalMissions = {
        {id = 'mine_1', label = 'Extraction non declaree', description = 'Miner de l\'or sans le declarer...', targetItem = 'gold_nugget', targetAmount = 3, reward = 800, time = 180000, xpBonus = 25},
        {id = 'mine_2', label = 'Vol de gemmes', description = 'Recuperer des emeraudes pour un receleur...', targetItem = 'emerald_crystal', targetAmount = 2, reward = 1200, time = 200000, xpBonus = 40},
        {id = 'mine_3', label = 'Diamants au noir', description = 'Des diamants qui n\'existent pas officiellement...', targetItem = 'diamond_crystal', targetAmount = 1, reward = 2000, time = 300000, xpBonus = 60},
        {id = 'mine_4', label = 'Contrebande de rubis', description = 'Un collectionneur veut des rubis discretement...', targetItem = 'ruby_crystal', targetAmount = 2, reward = 1500, time = 240000, xpBonus = 45},
        {id = 'mine_5', label = 'Detournement de quartz', description = 'Planquer du quartz pour un deal...', targetItem = 'quartz_crystal', targetAmount = 5, reward = 700, time = 150000, xpBonus = 20},
        {id = 'mine_6', label = 'Colis suspect', description = 'Deposer un colis dans la mine...', targetCoords = vector3(2940.12, 2790.34, 39.31), reward = 600, time = 120000, xpBonus = 15},
        {id = 'mine_7', label = 'Sabotage equipement', description = 'Endommager du materiel concurrent...', targetCoords = vector3(2975.45, 2760.67, 39.31), reward = 900, time = 150000, xpBonus = 30},
        {id = 'mine_8', label = 'Message code', description = 'Recuperer un message cache dans un filon...', targetCoords = vector3(2920.78, 2815.23, 39.31), reward = 500, time = 100000, xpBonus = 15},
        {id = 'mine_9', label = 'Stock illegal', description = 'Amasser du charbon non declare...', targetItem = 'coal_ore', targetAmount = 15, reward = 550, time = 180000, xpBonus = 20},
        {id = 'mine_10', label = 'Echange discret', description = 'Rencontrer quelqu\'un au fond de la mine...', targetCoords = vector3(3000.12, 2735.45, 39.31), reward = 1100, time = 180000, xpBonus = 35},
    },
}

-- =============================================================================
-- JOB 2: BUCHERON
-- =============================================================================

Config.Jobs['bucheron'] = {
    label = 'Bucheron',
    blip = {sprite = 77, color = 25, scale = 0.5, label = 'Scierie'},
    xpPerAction = 2,
    requiredAxes = {'axe_rusty', 'axe_iron', 'axe_mythical'},

    npcService = {
        model = 's_m_y_construct_02',
        coords = vector4(-537.09, 5252.53, 74.17, 90.0),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        label = 'Chef forestier',
    },

    npcShop = {
        model = 's_m_m_autoshop_02',
        coords = vector4(-540.23, 5248.67, 74.17, 45.0),
        scenario = 'WORLD_HUMAN_STAND_IMPATIENT',
        label = 'Vendeur haches',
        items = {
            {item = 'axe_rusty', price = 250, label = 'Hache rouillee'},
            {item = 'axe_iron', price = 750, label = 'Hache en fer'},
            {item = 'axe_mythical', price = 2500, label = 'Hache mythique'},
        }
    },

    npcSell = {
        model = 'a_m_m_farmer_01',
        coords = vector4(-580.45, 5220.12, 74.17, 180.0),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        label = 'Acheteur bois',
        prices = {['wood_log'] = 18}
    },

    startPoint = vector3(-537.09, 5252.53, 74.17),

    farmPoints = {
        {coords = vector3(-550.23, 5245.67, 74.17), label = 'Arbre', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(-525.45, 5260.89, 74.17), label = 'Arbre', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(-560.78, 5238.12, 74.17), label = 'Gros arbre', item = 'wood_log', minAmount = 3, maxAmount = 5, time = 14000},
        {coords = vector3(-515.34, 5268.45, 74.17), label = 'Arbre', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(-545.67, 5255.23, 74.17), label = 'Arbre', item = 'wood_log', minAmount = 2, maxAmount = 5, time = 13000},
        {coords = vector3(-532.12, 5248.78, 74.17), label = 'Arbre', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(-570.45, 5230.56, 74.17), label = 'Tres gros arbre', item = 'wood_log', minAmount = 4, maxAmount = 6, time = 18000},
        {coords = vector3(-505.67, 5275.34, 74.17), label = 'Arbre', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
    },

    animation = {dict = 'melee@large_wpn@streamed_core', anim = 'ground_attack_on_spot', flag = 1},
    prop = {model = 'prop_tool_fireaxe', bone = 28422, offset = vector3(0,0,0), rotation = vector3(0,0,0)},

    illegalMissions = {
        {id = 'lumb_1', label = 'Arbres proteges', description = 'Abattre des arbres classes illegalement...', targetItem = 'wood_log', targetAmount = 8, reward = 600, time = 180000, xpBonus = 30},
        {id = 'lumb_2', label = 'Bois au noir', description = 'Livrer du bois non declare...', targetItem = 'wood_log', targetAmount = 15, reward = 1100, time = 240000, xpBonus = 45},
        {id = 'lumb_3', label = 'Planque foret', description = 'Cacher un sac dans un tronc creux...', targetCoords = vector3(-555.34, 5240.12, 74.17), reward = 700, time = 120000, xpBonus = 25},
        {id = 'lumb_4', label = 'Intimidation', description = 'Faire peur a un concurrent...', targetCoords = vector3(-520.67, 5265.45, 74.17), reward = 800, time = 150000, xpBonus = 30},
        {id = 'lumb_5', label = 'Deforestation express', description = 'Raser une zone protegee en vitesse...', targetItem = 'wood_log', targetAmount = 20, reward = 1400, time = 300000, xpBonus = 50},
        {id = 'lumb_6', label = 'Message sous ecorce', description = 'Recuperer un message cache...', targetCoords = vector3(-565.12, 5235.78, 74.17), reward = 500, time = 100000, xpBonus = 15},
        {id = 'lumb_7', label = 'Vol de materiel', description = 'Piquer des outils dans un camion...', targetCoords = vector3(-575.45, 5225.34, 74.17), reward = 900, time = 150000, xpBonus = 35},
        {id = 'lumb_8', label = 'Faux accident', description = 'Simuler un accident de travail...', targetCoords = vector3(-530.78, 5250.12, 74.17), reward = 650, time = 120000, xpBonus = 20},
        {id = 'lumb_9', label = 'Contrebande bois rare', description = 'Sortir du bois precieux en douce...', targetItem = 'wood_log', targetAmount = 10, reward = 850, time = 200000, xpBonus = 35},
        {id = 'lumb_10', label = 'Rendez-vous suspect', description = 'Rencontrer un acheteur louche...', targetCoords = vector3(-510.34, 5270.67, 74.17), reward = 1000, time = 180000, xpBonus = 40},
    },
}

-- =============================================================================
-- JOB 3: BOUCHER
-- =============================================================================

Config.Jobs['boucher'] = {
    label = 'Boucher',
    blip = {sprite = 141, color = 1, scale = 0.5, label = 'Abattoir'},
    xpPerAction = 3,

    npcService = {
        model = 's_m_m_cntrybar_01',
        coords = vector4(967.12, -2150.45, 30.51, 270.0),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        label = 'Chef abattoir',
    },

    npcShop = {
        model = 's_m_y_chef_01',
        coords = vector4(970.34, -2145.67, 30.51, 180.0),
        scenario = 'WORLD_HUMAN_STAND_IMPATIENT',
        label = 'Fournisseur',
        items = {}
    },

    npcSell = {
        model = 'a_m_m_business_01',
        coords = vector4(940.12, -2175.45, 30.51, 90.0),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        label = 'Acheteur viande',
        prices = {
            ['meat_beef'] = 28, ['meat_pork'] = 22, ['meat_chicken'] = 15,
            ['meat_lamb'] = 32, ['raw_leather'] = 45,
        }
    },

    startPoint = vector3(967.12, -2150.45, 30.51),

    farmPoints = {
        {coords = vector3(975.34, -2145.67, 30.51), label = 'Depecer boeuf', item = 'meat_beef', minAmount = 3, maxAmount = 6, time = 15000},
        {coords = vector3(960.45, -2155.89, 30.51), label = 'Depecer porc', item = 'meat_pork', minAmount = 2, maxAmount = 5, time = 12000},
        {coords = vector3(980.67, -2138.12, 30.51), label = 'Depecer poulet', item = 'meat_chicken', minAmount = 4, maxAmount = 8, time = 8000},
        {coords = vector3(952.89, -2162.34, 30.51), label = 'Recuperer cuir', item = 'raw_leather', minAmount = 1, maxAmount = 3, time = 10000},
        {coords = vector3(988.12, -2130.56, 30.51), label = 'Depecer agneau', item = 'meat_lamb', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(945.34, -2168.78, 30.51), label = 'Recuperer cuir', item = 'raw_leather', minAmount = 2, maxAmount = 4, time = 10000},
    },

    animation = {dict = 'anim@amb@business@coc@coc_packing_cut@', anim = 'fullcut_cycle_v1_cokecutter', flag = 49},
    prop = {model = 'prop_cs_cleaver', bone = 28422, offset = vector3(0,0,0), rotation = vector3(0,0,0)},

    illegalMissions = {
        {id = 'butch_1', label = 'Viande perimee', description = 'Ecouler de la viande douteuse...', targetItem = 'meat_beef', targetAmount = 5, reward = 500, time = 150000, xpBonus = 25},
        {id = 'butch_2', label = 'Viande non tracee', description = 'Viande sans controle sanitaire...', targetItem = 'meat_pork', targetAmount = 8, reward = 750, time = 180000, xpBonus = 35},
        {id = 'butch_3', label = 'Cuir vole', description = 'Revendre du cuir au black...', targetItem = 'raw_leather', targetAmount = 6, reward = 900, time = 200000, xpBonus = 40},
        {id = 'butch_4', label = 'Colis dans la viande', description = 'Cacher quelque chose dans une carcasse...', targetCoords = vector3(965.45, -2155.12, 30.51), reward = 800, time = 120000, xpBonus = 30},
        {id = 'butch_5', label = 'Faux etiquetage', description = 'Changer les dates de peremption...', targetCoords = vector3(972.78, -2148.34, 30.51), reward = 600, time = 100000, xpBonus = 20},
        {id = 'butch_6', label = 'Livraison nocturne', description = 'Deposer de la viande chez un resto louche...', targetCoords = vector3(950.12, -2165.67, 30.51), reward = 700, time = 150000, xpBonus = 25},
        {id = 'butch_7', label = 'Vol de stock', description = 'Piquer dans les reserves...', targetItem = 'meat_lamb', targetAmount = 6, reward = 850, time = 180000, xpBonus = 35},
        {id = 'butch_8', label = 'Destruction preuves', description = 'Faire disparaitre des documents...', targetCoords = vector3(978.34, -2140.89, 30.51), reward = 550, time = 90000, xpBonus = 18},
        {id = 'butch_9', label = 'Viande de contrebande', description = 'Sortir de la marchandise en douce...', targetItem = 'meat_chicken', targetAmount = 15, reward = 650, time = 200000, xpBonus = 30},
        {id = 'butch_10', label = 'Rendez-vous frigo', description = 'Rencontrer un contact dans la chambre froide...', targetCoords = vector3(958.67, -2158.23, 30.51), reward = 1000, time = 150000, xpBonus = 40},
    },
}

-- =============================================================================
-- JOB 4: LIVREUR PIZZA
-- =============================================================================

Config.Jobs['livreur_pizza'] = {
    label = 'Livreur Pizza',
    blip = {sprite = 93, color = 47, scale = 0.5, label = 'Pizzeria'},
    xpPerAction = 3,

    npcService = {
        model = 's_m_y_pizza_01',
        coords = vector4(540.12, 100.45, 96.53, 45.0),
        scenario = 'WORLD_HUMAN_STAND_IMPATIENT',
        label = 'Gerant pizzeria',
    },

    npcShop = nil, -- Pas de shop pour ce job

    npcSell = nil, -- Pas de vente pour ce job

    startPoint = vector3(540.12, 100.45, 96.53),

    deliveryPickup = {coords = vector3(540.12, 100.45, 96.53), label = 'Recuperer commandes'},

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

    vehicle = {model = 'faggio', spawnPoint = vector4(542.34, 98.67, 96.53, 160.0)},
    animation = {dict = 'mp_common', anim = 'givetake1_a', flag = 49},
    bonusTime = 120,
    bonusAmount = 50,

    illegalMissions = {
        {id = 'pizza_1', label = 'Livraison douteuse', description = 'Un colis a livrer discretement...', targetCoords = vector3(-1550.45, -450.67, 40.52), reward = 900, time = 180000, xpBonus = 35},
        {id = 'pizza_2', label = 'Recuperation express', description = 'Recuperer une enveloppe...', targetCoords = vector3(150.23, -1050.45, 29.34), reward = 700, time = 150000, xpBonus = 30},
        {id = 'pizza_3', label = 'Pizza speciale', description = 'Livrer une pizza avec un extra cache...', targetCoords = vector3(-300.12, -850.34, 32.12), reward = 1100, time = 200000, xpBonus = 40},
        {id = 'pizza_4', label = 'Course contre la montre', description = 'Livrer avant que les flics arrivent...', targetCoords = vector3(400.45, -750.67, 29.45), reward = 800, time = 120000, xpBonus = 30},
        {id = 'pizza_5', label = 'Colis suspect', description = 'Transporter quelque chose de louche...', targetCoords = vector3(-500.78, -600.12, 35.67), reward = 950, time = 180000, xpBonus = 35},
        {id = 'pizza_6', label = 'Echange parking', description = 'Rendez-vous discret dans un parking...', targetCoords = vector3(200.34, -900.45, 30.12), reward = 750, time = 150000, xpBonus = 28},
        {id = 'pizza_7', label = 'Fausse livraison', description = 'Servir de couverture pour un deal...', targetCoords = vector3(-150.67, -750.89, 33.45), reward = 1000, time = 180000, xpBonus = 38},
        {id = 'pizza_8', label = 'Disparition', description = 'Faire disparaitre un telephone...', targetCoords = vector3(350.12, -650.34, 28.78), reward = 600, time = 100000, xpBonus = 20},
        {id = 'pizza_9', label = 'VIP louche', description = 'Livrer a un client tres special...', targetCoords = vector3(-800.45, -500.67, 27.34), reward = 1200, time = 200000, xpBonus = 45},
        {id = 'pizza_10', label = 'Double livraison', description = 'Deux adresses, un seul trajet...', targetCoords = vector3(100.78, -800.12, 31.56), reward = 850, time = 180000, xpBonus = 32},
    },
}

-- =============================================================================
-- JOB 5: EBOUEUR
-- =============================================================================

Config.Jobs['eboueur'] = {
    label = 'Eboueur',
    blip = {sprite = 318, color = 69, scale = 0.5, label = 'Depot Eboueurs'},
    xpPerAction = 2,

    npcService = {
        model = 's_m_y_garbage',
        coords = vector4(-322.45, -1545.67, 27.53, 180.0),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        label = 'Chef d\'equipe',
    },

    npcShop = nil,
    npcSell = nil,

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

    depositPoint = {coords = vector3(-350.12, -1560.45, 25.23), label = 'Deposer dechets', rewardPerBag = 25},
    vehicle = {model = 'trash', spawnPoint = vector4(-325.34, -1550.67, 27.53, 270.0)},
    animation = {dict = 'anim@move_m@trash', anim = 'pickup', flag = 49},

    illegalMissions = {
        {id = 'trash_1', label = 'Colis cache', description = 'Un paquet d\'argent dans une poubelle...', targetCoords = vector3(-280.45, -1560.78, 30.12), reward = 850, time = 120000, xpBonus = 30},
        {id = 'trash_2', label = 'Disparition discrete', description = 'Faire disparaitre un sac compromettant...', targetCoords = vector3(-195.67, -1500.23, 31.45), reward = 1100, time = 150000, xpBonus = 40},
        {id = 'trash_3', label = 'Tri special', description = 'Recuperer des objets dans les ordures...', targetCoords = vector3(-250.12, -1520.34, 30.89), reward = 700, time = 120000, xpBonus = 25},
        {id = 'trash_4', label = 'Destruction preuves', description = 'Broyer des documents compromettants...', targetCoords = vector3(-300.34, -1575.67, 29.12), reward = 950, time = 150000, xpBonus = 35},
        {id = 'trash_5', label = 'Transport discret', description = 'Deplacer un colis dans le camion...', targetCoords = vector3(-170.45, -1540.89, 32.34), reward = 800, time = 130000, xpBonus = 30},
        {id = 'trash_6', label = 'Fouille poubelles', description = 'Trouver une cle USB jetee...', targetCoords = vector3(-230.67, -1490.12, 31.67), reward = 650, time = 100000, xpBonus = 22},
        {id = 'trash_7', label = 'Depot nocturne', description = 'Deposer quelque chose dans une benne...', targetCoords = vector3(-290.78, -1590.45, 28.45), reward = 750, time = 120000, xpBonus = 28},
        {id = 'trash_8', label = 'Echange rapide', description = 'Echanger un sac avec un contact...', targetCoords = vector3(-210.12, -1510.67, 31.12), reward = 900, time = 140000, xpBonus = 33},
        {id = 'trash_9', label = 'Camion piege', description = 'Cacher quelque chose dans le compacteur...', targetCoords = vector3(-335.45, -1555.23, 27.89), reward = 1000, time = 150000, xpBonus = 38},
        {id = 'trash_10', label = 'Temoin muet', description = 'Faire comme si tu n\'avais rien vu...', targetCoords = vector3(-260.34, -1535.78, 30.56), reward = 1200, time = 180000, xpBonus = 45},
    },
}

-- =============================================================================
-- JOB 6: FACTEUR
-- =============================================================================

Config.Jobs['facteur'] = {
    label = 'Facteur',
    blip = {sprite = 478, color = 38, scale = 0.5, label = 'Bureau Poste'},
    xpPerAction = 2,

    npcService = {
        model = 's_m_m_postal_02',
        coords = vector4(105.45, -1568.67, 29.60, 0.0),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        label = 'Responsable courrier',
    },

    npcShop = nil,
    npcSell = nil,

    startPoint = vector3(105.45, -1568.67, 29.60),

    deliveryPickup = {coords = vector3(105.45, -1568.67, 29.60), label = 'Recuperer colis'},

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

    vehicle = {model = 'boxville2', spawnPoint = vector4(108.34, -1572.67, 29.60, 230.0)},
    animation = {dict = 'mp_common', anim = 'givetake1_a', flag = 49},

    illegalMissions = {
        {id = 'mail_1', label = 'Interception', description = 'Une enveloppe pleine de cash...', targetCoords = vector3(-150.34, -1510.67, 33.45), reward = 950, time = 120000, xpBonus = 35},
        {id = 'mail_2', label = 'Livraison secrete', description = 'Un colis tres discret...', targetCoords = vector3(200.45, -1560.23, 29.78), reward = 750, time = 150000, xpBonus = 30},
        {id = 'mail_3', label = 'Courrier piege', description = 'Deposer un colis special...', targetCoords = vector3(-100.12, -1540.45, 31.23), reward = 800, time = 130000, xpBonus = 32},
        {id = 'mail_4', label = 'Vol de courrier', description = 'Intercepter un colis precis...', targetCoords = vector3(150.67, -1505.78, 29.89), reward = 700, time = 120000, xpBonus = 28},
        {id = 'mail_5', label = 'Faux recommande', description = 'Faire signer un faux document...', targetCoords = vector3(-60.34, -1490.12, 31.45), reward = 650, time = 100000, xpBonus = 24},
        {id = 'mail_6', label = 'Echange boite', description = 'Echanger le contenu d\'un colis...', targetCoords = vector3(100.45, -1600.34, 29.34), reward = 850, time = 140000, xpBonus = 33},
        {id = 'mail_7', label = 'Livraison VIP', description = 'Un destinataire tres particulier...', targetCoords = vector3(-180.78, -1470.56, 32.67), reward = 1100, time = 180000, xpBonus = 42},
        {id = 'mail_8', label = 'Disparition colis', description = 'Faire disparaitre un envoi...', targetCoords = vector3(180.12, -1535.89, 29.56), reward = 600, time = 100000, xpBonus = 22},
        {id = 'mail_9', label = 'Double identite', description = 'Livrer sous un faux nom...', targetCoords = vector3(-30.45, -1560.12, 30.78), reward = 750, time = 130000, xpBonus = 28},
        {id = 'mail_10', label = 'Contact postal', description = 'Rencontrer quelqu\'un pendant la tournee...', targetCoords = vector3(230.67, -1590.34, 29.67), reward = 1000, time = 160000, xpBonus = 40},
    },
}

-- =============================================================================
-- JOB 7: AGENT D'ENTRETIEN
-- =============================================================================

Config.Jobs['agent_entretien'] = {
    label = 'Agent entretien',
    blip = {sprite = 556, color = 26, scale = 0.5, label = 'Societe Nettoyage'},
    xpPerAction = 2,

    npcService = {
        model = 's_m_y_clown_01',
        coords = vector4(-1395.67, -480.34, 72.04, 90.0),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        label = 'Responsable menage',
    },

    npcShop = nil,
    npcSell = nil,

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

    animation = {dict = 'amb@world_human_maid_clean@', anim = 'base', flag = 49},
    prop = {model = 'prop_mop_02', bone = 28422, offset = vector3(0,0,0), rotation = vector3(0,0,0)},

    illegalMissions = {
        {id = 'clean_1', label = 'Fouille discrete', description = 'Fouiller les bureaux pour du cash...', targetCoords = vector3(-1390.45, -480.67, 72.04), reward = 800, time = 120000, xpBonus = 30},
        {id = 'clean_2', label = 'Coffre oublie', description = 'Un petit coffre mal ferme...', targetCoords = vector3(-1360.23, -460.45, 72.04), reward = 1500, time = 180000, xpBonus = 50},
        {id = 'clean_3', label = 'Documents sensibles', description = 'Photographier des dossiers...', targetCoords = vector3(-1400.12, -495.34, 72.04), reward = 900, time = 140000, xpBonus = 35},
        {id = 'clean_4', label = 'Cle USB', description = 'Planter une cle USB sur un PC...', targetCoords = vector3(-1370.45, -470.78, 72.04), reward = 1100, time = 150000, xpBonus = 42},
        {id = 'clean_5', label = 'Ecoute', description = 'Poser un micro dans un bureau...', targetCoords = vector3(-1385.67, -485.12, 72.04), reward = 1200, time = 160000, xpBonus = 45},
        {id = 'clean_6', label = 'Vol de badge', description = 'Recuperer un badge d\'acces...', targetCoords = vector3(-1415.34, -505.45, 72.04), reward = 700, time = 100000, xpBonus = 25},
        {id = 'clean_7', label = 'Destruction dossier', description = 'Faire disparaitre des preuves...', targetCoords = vector3(-1355.78, -458.23, 72.04), reward = 850, time = 130000, xpBonus = 32},
        {id = 'clean_8', label = 'Acces interdit', description = 'Entrer dans une zone securisee...', targetCoords = vector3(-1430.12, -515.67, 72.04), reward = 1000, time = 150000, xpBonus = 38},
        {id = 'clean_9', label = 'Echange poubelle', description = 'Recuperer un sac jete volontairement...', targetCoords = vector3(-1378.45, -478.89, 72.04), reward = 650, time = 100000, xpBonus = 22},
        {id = 'clean_10', label = 'Nettoyage special', description = 'Faire disparaitre des traces...', targetCoords = vector3(-1395.23, -490.34, 72.04), reward = 1300, time = 180000, xpBonus = 48},
    },
}

-- =============================================================================
-- JOB 8: JARDINIER
-- =============================================================================

Config.Jobs['jardinier'] = {
    label = 'Jardinier',
    blip = {sprite = 808, color = 25, scale = 0.5, label = 'Espaces Verts'},
    xpPerAction = 2,

    npcService = {
        model = 's_m_y_construct_01',
        coords = vector4(-1222.45, -1475.67, 4.36, 270.0),
        scenario = 'WORLD_HUMAN_GARDENER_PLANT',
        label = 'Chef jardinier',
    },

    npcShop = nil,
    npcSell = nil,

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

    prop = {model = 'prop_tool_shovel', bone = 28422, offset = vector3(0,0,0), rotation = vector3(0,0,0)},

    illegalMissions = {
        {id = 'garden_1', label = 'Enterrer le magot', description = 'Enterrer un sac d\'argent...', targetCoords = vector3(-1230.45, -1470.67, 4.36), reward = 700, time = 120000, xpBonus = 25},
        {id = 'garden_2', label = 'Deterrer la planque', description = 'Recuperer un colis enterre...', targetCoords = vector3(-1200.23, -1490.45, 4.36), reward = 1200, time = 150000, xpBonus = 45},
        {id = 'garden_3', label = 'Plantation speciale', description = 'Planter quelque chose de discret...', targetCoords = vector3(-1245.67, -1460.12, 4.36), reward = 900, time = 130000, xpBonus = 35},
        {id = 'garden_4', label = 'Surveillance parc', description = 'Observer quelqu\'un discretement...', targetCoords = vector3(-1215.34, -1480.78, 4.36), reward = 600, time = 100000, xpBonus = 20},
        {id = 'garden_5', label = 'Message cache', description = 'Deposer un message sous une pierre...', targetCoords = vector3(-1255.78, -1450.34, 4.36), reward = 500, time = 90000, xpBonus = 18},
        {id = 'garden_6', label = 'Rendez-vous nature', description = 'Rencontrer un contact dans le parc...', targetCoords = vector3(-1190.12, -1500.56, 4.36), reward = 800, time = 130000, xpBonus = 30},
        {id = 'garden_7', label = 'Destruction evidence', description = 'Bruler des documents dehors...', targetCoords = vector3(-1235.45, -1465.89, 4.36), reward = 750, time = 110000, xpBonus = 28},
        {id = 'garden_8', label = 'Echange discret', description = 'Echanger un sac avec quelqu\'un...', targetCoords = vector3(-1205.67, -1485.23, 4.36), reward = 950, time = 140000, xpBonus = 36},
        {id = 'garden_9', label = 'Fouille buissons', description = 'Chercher un objet cache...', targetCoords = vector3(-1260.34, -1448.67, 4.36), reward = 650, time = 100000, xpBonus = 22},
        {id = 'garden_10', label = 'Transport vegetal', description = 'Sortir quelque chose dans une brouette...', targetCoords = vector3(-1175.78, -1510.12, 4.36), reward = 1100, time = 160000, xpBonus = 42},
    },
}
