Config = {}

-- =============================================================================
-- CONFIGURATION GENERALE
-- =============================================================================

Config.Debug = true
Config.DrawDistance = 10.0
Config.InteractDistance = 2.5
Config.FarmCooldown = 120000 -- 2 minutes en millisecondes

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

Config.Levels = {
    {xp = 0,    name = 'Debutant',    bonus = 1.0},
    {xp = 100,  name = 'Apprenti',    bonus = 1.1},
    {xp = 300,  name = 'Confirme',    bonus = 1.25},
    {xp = 600,  name = 'Expert',      bonus = 1.4},
    {xp = 1000, name = 'Maitre',      bonus = 1.6},
}

Config.IllegalMissions = {
    enabled = true,
    checkInterval = 300000,
    chance = 15,
    decisionTime = 30000,
    policeAlertChance = 10,
    cooldown = 600000,
}

Config.Jobs = {}

-- =============================================================================
-- JOB 1: MINEUR (20 points)
-- =============================================================================

Config.Jobs['mineur'] = {
    label = 'Mineur',
    blip = {sprite = 618, color = 40, scale = 0.5, label = 'Mine'},
    xpPerAction = 2,
    requiredItem = 'pickaxe',

    npcService = {
        model = 's_m_y_construct_01',
        coords = vector4(2959.54, 2774.36, 39.31, 180.0),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        label = 'Chef de chantier',
    },

    npcShop = {
        model = 's_m_m_lathandy_01',
        coords = vector4(2955.12, 2778.45, 39.31, 220.0),
        scenario = 'WORLD_HUMAN_STAND_IMPATIENT',
        label = 'Vendeur outils',
        items = {
            {item = 'pickaxe', price = 500, label = 'Pioche'},
        }
    },

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
        -- Zone charbon (facile)
        {coords = vector3(2950.12, 2780.45, 39.31), label = 'Veine de charbon', item = 'coal_ore', minAmount = 1, maxAmount = 3, time = 6000},
        {coords = vector3(2947.34, 2783.67, 39.31), label = 'Veine de charbon', item = 'coal_ore', minAmount = 1, maxAmount = 3, time = 6000},
        {coords = vector3(2953.56, 2777.23, 39.31), label = 'Veine de charbon', item = 'coal_ore', minAmount = 2, maxAmount = 4, time = 7000},
        {coords = vector3(2944.78, 2786.89, 39.31), label = 'Depot de soufre', item = 'sulfur_chunk', minAmount = 1, maxAmount = 2, time = 7000},
        -- Zone silex
        {coords = vector3(2962.34, 2769.12, 39.31), label = 'Roche de silex', item = 'flint', minAmount = 1, maxAmount = 2, time = 5000},
        {coords = vector3(2965.56, 2766.34, 39.31), label = 'Roche de silex', item = 'flint', minAmount = 1, maxAmount = 3, time = 5500},
        {coords = vector3(2959.78, 2772.56, 39.31), label = 'Roche de silex', item = 'flint', minAmount = 1, maxAmount = 2, time = 5000},
        -- Zone or
        {coords = vector3(2970.89, 2762.56, 39.31), label = 'Veine d\'or', item = 'gold_nugget', minAmount = 1, maxAmount = 1, time = 10000},
        {coords = vector3(2973.12, 2759.78, 39.31), label = 'Veine d\'or', item = 'gold_nugget', minAmount = 1, maxAmount = 2, time = 12000},
        {coords = vector3(2938.45, 2795.78, 39.31), label = 'Sable aurifere', item = 'gold_dust', minAmount = 1, maxAmount = 2, time = 8000},
        {coords = vector3(2941.67, 2792.12, 39.31), label = 'Sable aurifere', item = 'gold_dust', minAmount = 1, maxAmount = 3, time = 9000},
        -- Zone cristaux
        {coords = vector3(2978.12, 2755.34, 39.31), label = 'Cristal de quartz', item = 'quartz_crystal', minAmount = 1, maxAmount = 1, time = 12000},
        {coords = vector3(2981.34, 2752.56, 39.31), label = 'Quartz violet', item = 'purple_quartz', minAmount = 1, maxAmount = 1, time = 13000},
        {coords = vector3(2932.56, 2802.12, 39.31), label = 'Emeraude brute', item = 'emerald_crystal', minAmount = 1, maxAmount = 1, time = 15000},
        {coords = vector3(2929.78, 2805.34, 39.31), label = 'Grenat vert', item = 'green_garnet', minAmount = 1, maxAmount = 1, time = 11000},
        -- Zone precieuse
        {coords = vector3(2985.34, 2748.67, 39.31), label = 'Rubis brut', item = 'ruby_crystal', minAmount = 1, maxAmount = 1, time = 18000},
        {coords = vector3(2988.56, 2745.89, 39.31), label = 'Saphir rose', item = 'pink_sapphire', minAmount = 1, maxAmount = 1, time = 16000},
        {coords = vector3(2912.23, 2822.34, 39.31), label = 'Geode amethyste', item = 'amethyst_geode', minAmount = 1, maxAmount = 1, time = 20000},
        -- Zone diamants
        {coords = vector3(3005.45, 2728.56, 39.31), label = 'Diamant brut', item = 'diamond_crystal', minAmount = 1, maxAmount = 1, time = 25000},
        {coords = vector3(3008.67, 2725.78, 39.31), label = 'Diamant bleu', item = 'blue_diamond', minAmount = 1, maxAmount = 1, time = 30000},
    },

    animation = {dict = 'amb@world_human_hammering@male@base', anim = 'base', flag = 49},

    illegalMissions = {
        {id = 'mine_1', label = 'Extraction non declaree', description = 'Miner de l\'or sans le declarer...', targetItem = 'gold_nugget', targetAmount = 3, reward = 800, time = 180000, xpBonus = 25},
        {id = 'mine_2', label = 'Vol de gemmes', description = 'Recuperer des emeraudes pour un receleur...', targetItem = 'emerald_crystal', targetAmount = 2, reward = 1200, time = 200000, xpBonus = 40},
        {id = 'mine_3', label = 'Diamants au noir', description = 'Des diamants qui n\'existent pas officiellement...', targetItem = 'diamond_crystal', targetAmount = 1, reward = 2000, time = 300000, xpBonus = 60},
        {id = 'mine_4', label = 'Contrebande rubis', description = 'Un collectionneur veut des rubis...', targetItem = 'ruby_crystal', targetAmount = 2, reward = 1500, time = 240000, xpBonus = 45},
        {id = 'mine_5', label = 'Stock illegal', description = 'Amasser du charbon non declare...', targetItem = 'coal_ore', targetAmount = 15, reward = 550, time = 180000, xpBonus = 20},
        {id = 'mine_6', label = 'Colis suspect', description = 'Deposer un colis dans la mine...', targetCoords = vector3(2940.12, 2790.34, 39.31), reward = 600, time = 120000, xpBonus = 15},
        {id = 'mine_7', label = 'Sabotage', description = 'Endommager du materiel concurrent...', targetCoords = vector3(2975.45, 2760.67, 39.31), reward = 900, time = 150000, xpBonus = 30},
        {id = 'mine_8', label = 'Message code', description = 'Recuperer un message cache...', targetCoords = vector3(2920.78, 2815.23, 39.31), reward = 500, time = 100000, xpBonus = 15},
        {id = 'mine_9', label = 'Detournement quartz', description = 'Planquer du quartz...', targetItem = 'quartz_crystal', targetAmount = 5, reward = 700, time = 150000, xpBonus = 20},
        {id = 'mine_10', label = 'Echange discret', description = 'Rencontrer quelqu\'un au fond...', targetCoords = vector3(3000.12, 2735.45, 39.31), reward = 1100, time = 180000, xpBonus = 35},
    },
}

-- =============================================================================
-- JOB 2: BUCHERON (20 points)
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
        {coords = vector3(-550.23, 5245.67, 74.17), label = 'Pin', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(-553.45, 5242.89, 74.17), label = 'Sapin', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(-556.67, 5240.12, 74.17), label = 'Chene', item = 'wood_log', minAmount = 3, maxAmount = 5, time = 14000},
        {coords = vector3(-525.45, 5260.89, 74.17), label = 'Bouleau', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 11000},
        {coords = vector3(-528.67, 5257.12, 74.17), label = 'Erable', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(-531.89, 5254.34, 74.17), label = 'Frene', item = 'wood_log', minAmount = 2, maxAmount = 3, time = 11000},
        {coords = vector3(-560.78, 5238.12, 74.17), label = 'Vieux chene', item = 'wood_log', minAmount = 4, maxAmount = 6, time = 16000},
        {coords = vector3(-563.12, 5235.34, 74.17), label = 'Sequoia', item = 'wood_log', minAmount = 5, maxAmount = 7, time = 18000},
        {coords = vector3(-515.34, 5268.45, 74.17), label = 'Pin sylvestre', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(-518.56, 5265.67, 74.17), label = 'Epicea', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(-521.78, 5262.89, 74.17), label = 'Cedre', item = 'wood_log', minAmount = 3, maxAmount = 5, time = 13000},
        {coords = vector3(-545.67, 5255.23, 74.17), label = 'Hetre', item = 'wood_log', minAmount = 2, maxAmount = 5, time = 13000},
        {coords = vector3(-548.89, 5252.45, 74.17), label = 'Tilleul', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 11000},
        {coords = vector3(-532.12, 5248.78, 74.17), label = 'Peuplier', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 10000},
        {coords = vector3(-535.34, 5245.12, 74.17), label = 'Aulne', item = 'wood_log', minAmount = 2, maxAmount = 3, time = 10000},
        {coords = vector3(-570.45, 5230.56, 74.17), label = 'Geant centenaire', item = 'wood_log', minAmount = 6, maxAmount = 8, time = 20000},
        {coords = vector3(-505.67, 5275.34, 74.17), label = 'Saule', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 11000},
        {coords = vector3(-508.89, 5272.56, 74.17), label = 'Noyer', item = 'wood_log', minAmount = 3, maxAmount = 5, time = 14000},
        {coords = vector3(-512.12, 5269.78, 74.17), label = 'Merisier', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
        {coords = vector3(-538.34, 5242.12, 74.17), label = 'Charme', item = 'wood_log', minAmount = 2, maxAmount = 4, time = 12000},
    },

    animation = {dict = 'melee@large_wpn@streamed_core', anim = 'ground_attack_on_spot', flag = 1},

    illegalMissions = {
        {id = 'lumb_1', label = 'Arbres proteges', description = 'Abattre des arbres classes...', targetItem = 'wood_log', targetAmount = 10, reward = 700, time = 200000, xpBonus = 30},
        {id = 'lumb_2', label = 'Bois au noir', description = 'Livrer du bois non declare...', targetItem = 'wood_log', targetAmount = 20, reward = 1200, time = 280000, xpBonus = 50},
        {id = 'lumb_3', label = 'Planque foret', description = 'Cacher un sac dans un tronc...', targetCoords = vector3(-555.34, 5240.12, 74.17), reward = 700, time = 120000, xpBonus = 25},
        {id = 'lumb_4', label = 'Intimidation', description = 'Faire peur a un concurrent...', targetCoords = vector3(-520.67, 5265.45, 74.17), reward = 800, time = 150000, xpBonus = 30},
        {id = 'lumb_5', label = 'Deforestation', description = 'Raser une zone protegee...', targetItem = 'wood_log', targetAmount = 25, reward = 1500, time = 350000, xpBonus = 55},
        {id = 'lumb_6', label = 'Message ecorce', description = 'Recuperer un message cache...', targetCoords = vector3(-565.12, 5235.78, 74.17), reward = 500, time = 100000, xpBonus = 15},
        {id = 'lumb_7', label = 'Vol materiel', description = 'Piquer des outils...', targetCoords = vector3(-575.45, 5225.34, 74.17), reward = 900, time = 150000, xpBonus = 35},
        {id = 'lumb_8', label = 'Faux accident', description = 'Simuler un accident...', targetCoords = vector3(-530.78, 5250.12, 74.17), reward = 650, time = 120000, xpBonus = 20},
        {id = 'lumb_9', label = 'Contrebande', description = 'Sortir du bois en douce...', targetItem = 'wood_log', targetAmount = 15, reward = 950, time = 240000, xpBonus = 40},
        {id = 'lumb_10', label = 'Rendez-vous', description = 'Rencontrer un acheteur louche...', targetCoords = vector3(-510.34, 5270.67, 74.17), reward = 1000, time = 180000, xpBonus = 40},
    },
}

-- =============================================================================
-- JOB 3: BOUCHER (20 points - etapes realistes)
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
        items = {
            {item = 'butcher_knife', price = 300, label = 'Couteau boucher'},
        }
    },

    npcSell = {
        model = 'a_m_m_business_01',
        coords = vector4(940.12, -2175.45, 30.51, 90.0),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        label = 'Acheteur viande',
        prices = {
            ['meat_beef'] = 28, ['meat_pork'] = 22, ['meat_chicken'] = 15,
            ['meat_lamb'] = 32, ['raw_leather'] = 45,
            ['meat_beef_cut'] = 35, ['meat_pork_cut'] = 28, ['meat_packed'] = 50,
        }
    },

    startPoint = vector3(967.12, -2150.45, 30.51),

    farmPoints = {
        -- Zone depecage boeuf
        {coords = vector3(975.34, -2145.67, 30.51), label = 'Depecer boeuf', item = 'meat_beef', minAmount = 3, maxAmount = 5, time = 12000},
        {coords = vector3(978.56, -2142.89, 30.51), label = 'Depecer boeuf', item = 'meat_beef', minAmount = 3, maxAmount = 5, time = 12000},
        {coords = vector3(981.78, -2140.12, 30.51), label = 'Decouper boeuf', item = 'meat_beef_cut', minAmount = 2, maxAmount = 4, time = 10000},
        {coords = vector3(984.12, -2137.34, 30.51), label = 'Emballer boeuf', item = 'meat_packed', minAmount = 1, maxAmount = 2, time = 8000},
        -- Zone porc
        {coords = vector3(960.45, -2155.89, 30.51), label = 'Depecer porc', item = 'meat_pork', minAmount = 2, maxAmount = 4, time = 10000},
        {coords = vector3(957.67, -2158.12, 30.51), label = 'Depecer porc', item = 'meat_pork', minAmount = 2, maxAmount = 4, time = 10000},
        {coords = vector3(954.89, -2160.34, 30.51), label = 'Decouper porc', item = 'meat_pork_cut', minAmount = 2, maxAmount = 3, time = 9000},
        {coords = vector3(952.12, -2162.56, 30.51), label = 'Emballer porc', item = 'meat_packed', minAmount = 1, maxAmount = 2, time = 8000},
        -- Zone poulet
        {coords = vector3(980.67, -2138.12, 30.51), label = 'Plumer poulet', item = 'meat_chicken', minAmount = 2, maxAmount = 4, time = 6000},
        {coords = vector3(983.89, -2135.34, 30.51), label = 'Plumer poulet', item = 'meat_chicken', minAmount = 2, maxAmount = 4, time = 6000},
        {coords = vector3(987.12, -2132.56, 30.51), label = 'Eviscerer poulet', item = 'meat_chicken', minAmount = 3, maxAmount = 5, time = 7000},
        {coords = vector3(990.34, -2129.78, 30.51), label = 'Emballer poulet', item = 'meat_packed', minAmount = 1, maxAmount = 2, time = 6000},
        -- Zone agneau
        {coords = vector3(988.12, -2130.56, 30.51), label = 'Depecer agneau', item = 'meat_lamb', minAmount = 2, maxAmount = 3, time = 11000},
        {coords = vector3(991.34, -2127.78, 30.51), label = 'Depecer agneau', item = 'meat_lamb', minAmount = 2, maxAmount = 3, time = 11000},
        {coords = vector3(994.56, -2125.12, 30.51), label = 'Decouper agneau', item = 'meat_lamb', minAmount = 2, maxAmount = 4, time = 10000},
        -- Zone cuir
        {coords = vector3(945.34, -2168.78, 30.51), label = 'Tanner cuir', item = 'raw_leather', minAmount = 1, maxAmount = 2, time = 15000},
        {coords = vector3(948.56, -2165.12, 30.51), label = 'Tanner cuir', item = 'raw_leather', minAmount = 1, maxAmount = 2, time = 15000},
        {coords = vector3(951.78, -2162.34, 30.51), label = 'Preparer cuir', item = 'raw_leather', minAmount = 1, maxAmount = 3, time = 12000},
        -- Zone supplementaire
        {coords = vector3(972.12, -2148.56, 30.51), label = 'Hacher viande', item = 'meat_beef_cut', minAmount = 2, maxAmount = 4, time = 8000},
        {coords = vector3(969.34, -2151.78, 30.51), label = 'Conditionner', item = 'meat_packed', minAmount = 2, maxAmount = 3, time = 10000},
    },

    animation = {dict = 'anim@amb@business@coc@coc_packing_cut@', anim = 'fullcut_cycle_v1_cokecutter', flag = 49},

    illegalMissions = {
        {id = 'butch_1', label = 'Viande perimee', description = 'Ecouler de la viande douteuse...', targetItem = 'meat_beef', targetAmount = 6, reward = 550, time = 160000, xpBonus = 25},
        {id = 'butch_2', label = 'Viande non tracee', description = 'Viande sans controle sanitaire...', targetItem = 'meat_pork', targetAmount = 10, reward = 800, time = 200000, xpBonus = 35},
        {id = 'butch_3', label = 'Cuir vole', description = 'Revendre du cuir au black...', targetItem = 'raw_leather', targetAmount = 5, reward = 950, time = 220000, xpBonus = 40},
        {id = 'butch_4', label = 'Colis viande', description = 'Cacher quelque chose...', targetCoords = vector3(965.45, -2155.12, 30.51), reward = 800, time = 120000, xpBonus = 30},
        {id = 'butch_5', label = 'Faux etiquetage', description = 'Changer les dates...', targetCoords = vector3(972.78, -2148.34, 30.51), reward = 600, time = 100000, xpBonus = 20},
        {id = 'butch_6', label = 'Livraison nocturne', description = 'Deposer chez un resto louche...', targetCoords = vector3(950.12, -2165.67, 30.51), reward = 700, time = 150000, xpBonus = 25},
        {id = 'butch_7', label = 'Vol de stock', description = 'Piquer dans les reserves...', targetItem = 'meat_lamb', targetAmount = 8, reward = 900, time = 200000, xpBonus = 38},
        {id = 'butch_8', label = 'Destruction preuves', description = 'Faire disparaitre des documents...', targetCoords = vector3(978.34, -2140.89, 30.51), reward = 550, time = 90000, xpBonus = 18},
        {id = 'butch_9', label = 'Contrebande', description = 'Sortir de la marchandise...', targetItem = 'meat_chicken', targetAmount = 15, reward = 700, time = 220000, xpBonus = 32},
        {id = 'butch_10', label = 'Rendez-vous frigo', description = 'Rencontrer un contact...', targetCoords = vector3(958.67, -2158.23, 30.51), reward = 1050, time = 160000, xpBonus = 42},
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

    npcShop = nil,
    npcSell = nil,

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
        {id = 'pizza_1', label = 'Livraison douteuse', description = 'Un colis a livrer...', targetCoords = vector3(-1550.45, -450.67, 40.52), reward = 900, time = 180000, xpBonus = 35},
        {id = 'pizza_2', label = 'Recuperation express', description = 'Recuperer une enveloppe...', targetCoords = vector3(150.23, -1050.45, 29.34), reward = 700, time = 150000, xpBonus = 30},
        {id = 'pizza_3', label = 'Pizza speciale', description = 'Extra cache dedans...', targetCoords = vector3(-300.12, -850.34, 32.12), reward = 1100, time = 200000, xpBonus = 40},
        {id = 'pizza_4', label = 'Course montre', description = 'Livrer avant les flics...', targetCoords = vector3(400.45, -750.67, 29.45), reward = 800, time = 120000, xpBonus = 30},
        {id = 'pizza_5', label = 'Colis suspect', description = 'Transporter quelque chose...', targetCoords = vector3(-500.78, -600.12, 35.67), reward = 950, time = 180000, xpBonus = 35},
        {id = 'pizza_6', label = 'Echange parking', description = 'Rendez-vous discret...', targetCoords = vector3(200.34, -900.45, 30.12), reward = 750, time = 150000, xpBonus = 28},
        {id = 'pizza_7', label = 'Fausse livraison', description = 'Couverture pour un deal...', targetCoords = vector3(-150.67, -750.89, 33.45), reward = 1000, time = 180000, xpBonus = 38},
        {id = 'pizza_8', label = 'Disparition', description = 'Faire disparaitre un tel...', targetCoords = vector3(350.12, -650.34, 28.78), reward = 600, time = 100000, xpBonus = 20},
        {id = 'pizza_9', label = 'VIP louche', description = 'Client tres special...', targetCoords = vector3(-800.45, -500.67, 27.34), reward = 1200, time = 200000, xpBonus = 45},
        {id = 'pizza_10', label = 'Double livraison', description = 'Deux adresses...', targetCoords = vector3(100.78, -800.12, 31.56), reward = 850, time = 180000, xpBonus = 32},
    },
}

-- =============================================================================
-- JOB 5: EBOUEUR (15 points)
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
        {coords = vector3(-245.34, -1510.67, 30.53), label = 'Poubelle verte', time = 4000},
        {coords = vector3(-248.56, -1507.89, 30.53), label = 'Poubelle bleue', time = 4000},
        {coords = vector3(-198.45, -1485.89, 31.22), label = 'Conteneur', time = 5000},
        {coords = vector3(-201.67, -1483.12, 31.22), label = 'Poubelle', time = 4000},
        {coords = vector3(-156.67, -1520.12, 32.45), label = 'Benne', time = 6000},
        {coords = vector3(-159.89, -1517.34, 32.45), label = 'Poubelle', time = 4000},
        {coords = vector3(-285.89, -1580.34, 29.67), label = 'Conteneur', time = 5000},
        {coords = vector3(-288.12, -1577.56, 29.67), label = 'Poubelle', time = 4000},
        {coords = vector3(-310.12, -1605.56, 28.89), label = 'Grande benne', time = 7000},
        {coords = vector3(-178.34, -1550.78, 33.12), label = 'Poubelle', time = 4000},
        {coords = vector3(-181.56, -1548.12, 33.12), label = 'Poubelle', time = 4000},
        {coords = vector3(-225.56, -1475.12, 31.78), label = 'Conteneur', time = 5000},
        {coords = vector3(-228.78, -1472.34, 31.78), label = 'Poubelle', time = 4000},
        {coords = vector3(-265.78, -1545.45, 30.34), label = 'Benne', time = 6000},
        {coords = vector3(-268.12, -1542.67, 30.34), label = 'Poubelle', time = 4000},
    },

    depositPoint = {coords = vector3(-350.12, -1560.45, 25.23), label = 'Deposer dechets', rewardPerBag = 25},
    vehicle = {model = 'trash', spawnPoint = vector4(-325.34, -1550.67, 27.53, 270.0)},
    animation = {dict = 'anim@move_m@trash', anim = 'pickup', flag = 49},

    illegalMissions = {
        {id = 'trash_1', label = 'Colis cache', description = 'Argent dans une poubelle...', targetCoords = vector3(-280.45, -1560.78, 30.12), reward = 850, time = 120000, xpBonus = 30},
        {id = 'trash_2', label = 'Disparition discrete', description = 'Faire disparaitre un sac...', targetCoords = vector3(-195.67, -1500.23, 31.45), reward = 1100, time = 150000, xpBonus = 40},
        {id = 'trash_3', label = 'Tri special', description = 'Recuperer des objets...', targetCoords = vector3(-250.12, -1520.34, 30.89), reward = 700, time = 120000, xpBonus = 25},
        {id = 'trash_4', label = 'Destruction preuves', description = 'Broyer des documents...', targetCoords = vector3(-300.34, -1575.67, 29.12), reward = 950, time = 150000, xpBonus = 35},
        {id = 'trash_5', label = 'Transport discret', description = 'Deplacer un colis...', targetCoords = vector3(-170.45, -1540.89, 32.34), reward = 800, time = 130000, xpBonus = 30},
        {id = 'trash_6', label = 'Fouille', description = 'Trouver une cle USB...', targetCoords = vector3(-230.67, -1490.12, 31.67), reward = 650, time = 100000, xpBonus = 22},
        {id = 'trash_7', label = 'Depot nocturne', description = 'Deposer dans une benne...', targetCoords = vector3(-290.78, -1590.45, 28.45), reward = 750, time = 120000, xpBonus = 28},
        {id = 'trash_8', label = 'Echange rapide', description = 'Echanger un sac...', targetCoords = vector3(-210.12, -1510.67, 31.12), reward = 900, time = 140000, xpBonus = 33},
        {id = 'trash_9', label = 'Camion piege', description = 'Cacher dans le compacteur...', targetCoords = vector3(-335.45, -1555.23, 27.89), reward = 1000, time = 150000, xpBonus = 38},
        {id = 'trash_10', label = 'Temoin muet', description = 'Tu n\'as rien vu...', targetCoords = vector3(-260.34, -1535.78, 30.56), reward = 1200, time = 180000, xpBonus = 45},
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
        {id = 'mail_1', label = 'Interception', description = 'Enveloppe pleine de cash...', targetCoords = vector3(-150.34, -1510.67, 33.45), reward = 950, time = 120000, xpBonus = 35},
        {id = 'mail_2', label = 'Livraison secrete', description = 'Colis tres discret...', targetCoords = vector3(200.45, -1560.23, 29.78), reward = 750, time = 150000, xpBonus = 30},
        {id = 'mail_3', label = 'Courrier piege', description = 'Deposer un colis special...', targetCoords = vector3(-100.12, -1540.45, 31.23), reward = 800, time = 130000, xpBonus = 32},
        {id = 'mail_4', label = 'Vol courrier', description = 'Intercepter un colis...', targetCoords = vector3(150.67, -1505.78, 29.89), reward = 700, time = 120000, xpBonus = 28},
        {id = 'mail_5', label = 'Faux recommande', description = 'Faux document...', targetCoords = vector3(-60.34, -1490.12, 31.45), reward = 650, time = 100000, xpBonus = 24},
        {id = 'mail_6', label = 'Echange boite', description = 'Echanger contenu...', targetCoords = vector3(100.45, -1600.34, 29.34), reward = 850, time = 140000, xpBonus = 33},
        {id = 'mail_7', label = 'Livraison VIP', description = 'Destinataire special...', targetCoords = vector3(-180.78, -1470.56, 32.67), reward = 1100, time = 180000, xpBonus = 42},
        {id = 'mail_8', label = 'Disparition colis', description = 'Faire disparaitre...', targetCoords = vector3(180.12, -1535.89, 29.56), reward = 600, time = 100000, xpBonus = 22},
        {id = 'mail_9', label = 'Double identite', description = 'Livrer sous faux nom...', targetCoords = vector3(-30.45, -1560.12, 30.78), reward = 750, time = 130000, xpBonus = 28},
        {id = 'mail_10', label = 'Contact postal', description = 'Rencontrer quelqu\'un...', targetCoords = vector3(230.67, -1590.34, 29.67), reward = 1000, time = 160000, xpBonus = 40},
    },
}

-- =============================================================================
-- JOB 7: AGENT ENTRETIEN (15 points)
-- =============================================================================

Config.Jobs['agent_entretien'] = {
    label = 'Agent entretien',
    blip = {sprite = 556, color = 26, scale = 0.5, label = 'Societe Nettoyage'},
    xpPerAction = 2,

    npcService = {
        model = 's_m_y_winclean_01',
        coords = vector4(-1395.67, -480.34, 72.04, 90.0),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        label = 'Responsable menage',
    },

    npcShop = nil,
    npcSell = nil,

    startPoint = vector3(-1395.67, -480.34, 72.04),

    cleanPoints = {
        {coords = vector3(-1380.34, -475.67, 72.04), label = 'Laver sol', time = 6000, reward = 35},
        {coords = vector3(-1383.56, -472.89, 72.04), label = 'Laver sol', time = 6000, reward = 35},
        {coords = vector3(-1405.45, -490.89, 72.04), label = 'Nettoyer vitres', time = 8000, reward = 45},
        {coords = vector3(-1408.67, -488.12, 72.04), label = 'Nettoyer vitres', time = 8000, reward = 45},
        {coords = vector3(-1365.67, -465.12, 72.04), label = 'Aspirer moquette', time = 7000, reward = 40},
        {coords = vector3(-1368.89, -462.34, 72.04), label = 'Aspirer moquette', time = 7000, reward = 40},
        {coords = vector3(-1420.89, -505.34, 72.04), label = 'Vider poubelles', time = 4000, reward = 25},
        {coords = vector3(-1423.12, -502.56, 72.04), label = 'Vider poubelles', time = 4000, reward = 25},
        {coords = vector3(-1350.12, -455.56, 72.04), label = 'Nettoyer WC', time = 10000, reward = 60},
        {coords = vector3(-1353.34, -452.78, 72.04), label = 'Nettoyer lavabos', time = 8000, reward = 50},
        {coords = vector3(-1435.34, -520.78, 72.04), label = 'Cirer parquet', time = 9000, reward = 55},
        {coords = vector3(-1375.56, -485.12, 72.04), label = 'Desinfecter', time = 7000, reward = 42},
        {coords = vector3(-1378.78, -482.34, 72.04), label = 'Depoussierer', time = 5000, reward = 30},
        {coords = vector3(-1410.78, -500.45, 72.04), label = 'Vider corbeilles', time = 4000, reward = 25},
        {coords = vector3(-1413.12, -497.67, 72.04), label = 'Ranger bureau', time = 6000, reward = 38},
    },

    animation = {dict = 'amb@world_human_maid_clean@', anim = 'base', flag = 49},
    prop = {model = 'prop_mop_02', bone = 28422, offset = vector3(0,0,0), rotation = vector3(0,0,0)},

    illegalMissions = {
        {id = 'clean_1', label = 'Fouille discrete', description = 'Fouiller pour du cash...', targetCoords = vector3(-1390.45, -480.67, 72.04), reward = 800, time = 120000, xpBonus = 30},
        {id = 'clean_2', label = 'Coffre oublie', description = 'Coffre mal ferme...', targetCoords = vector3(-1360.23, -460.45, 72.04), reward = 1500, time = 180000, xpBonus = 50},
        {id = 'clean_3', label = 'Documents', description = 'Photographier dossiers...', targetCoords = vector3(-1400.12, -495.34, 72.04), reward = 900, time = 140000, xpBonus = 35},
        {id = 'clean_4', label = 'Cle USB', description = 'Planter sur un PC...', targetCoords = vector3(-1370.45, -470.78, 72.04), reward = 1100, time = 150000, xpBonus = 42},
        {id = 'clean_5', label = 'Ecoute', description = 'Poser un micro...', targetCoords = vector3(-1385.67, -485.12, 72.04), reward = 1200, time = 160000, xpBonus = 45},
        {id = 'clean_6', label = 'Vol badge', description = 'Recuperer un badge...', targetCoords = vector3(-1415.34, -505.45, 72.04), reward = 700, time = 100000, xpBonus = 25},
        {id = 'clean_7', label = 'Destruction', description = 'Faire disparaitre preuves...', targetCoords = vector3(-1355.78, -458.23, 72.04), reward = 850, time = 130000, xpBonus = 32},
        {id = 'clean_8', label = 'Acces interdit', description = 'Zone securisee...', targetCoords = vector3(-1430.12, -515.67, 72.04), reward = 1000, time = 150000, xpBonus = 38},
        {id = 'clean_9', label = 'Echange poubelle', description = 'Recuperer un sac...', targetCoords = vector3(-1378.45, -478.89, 72.04), reward = 650, time = 100000, xpBonus = 22},
        {id = 'clean_10', label = 'Nettoyage special', description = 'Faire disparaitre traces...', targetCoords = vector3(-1395.23, -490.34, 72.04), reward = 1300, time = 180000, xpBonus = 48},
    },
}

-- =============================================================================
-- JOB 8: JARDINIER (15 points - animations realistes)
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

    npcShop = {
        model = 'a_m_m_farmer_01',
        coords = vector4(-1226.67, -1472.89, 4.36, 180.0),
        scenario = 'WORLD_HUMAN_STAND_IMPATIENT',
        label = 'Fournisseur outils',
        items = {
            {item = 'garden_shears', price = 200, label = 'Secateur'},
            {item = 'garden_rake', price = 150, label = 'Rateau'},
        }
    },

    npcSell = nil,

    startPoint = vector3(-1222.45, -1475.67, 4.36),

    gardenPoints = {
        -- Tonte (animation tondeuse)
        {coords = vector3(-1235.34, -1465.67, 4.36), label = 'Tondre pelouse', time = 12000, reward = 55, type = 'tondre'},
        {coords = vector3(-1238.56, -1462.89, 4.36), label = 'Tondre pelouse', time = 12000, reward = 55, type = 'tondre'},
        {coords = vector3(-1265.12, -1445.56, 4.36), label = 'Tondre grande zone', time = 15000, reward = 70, type = 'tondre'},
        -- Taille haies
        {coords = vector3(-1210.45, -1485.89, 4.36), label = 'Tailler haie', time = 8000, reward = 45, type = 'tailler'},
        {coords = vector3(-1213.67, -1483.12, 4.36), label = 'Tailler haie', time = 8000, reward = 45, type = 'tailler'},
        {coords = vector3(-1180.34, -1505.78, 4.36), label = 'Tailler arbuste', time = 10000, reward = 52, type = 'tailler'},
        -- Arrosage
        {coords = vector3(-1250.67, -1455.12, 4.36), label = 'Arroser massif', time = 6000, reward = 32, type = 'arroser'},
        {coords = vector3(-1253.89, -1452.34, 4.36), label = 'Arroser fleurs', time = 5000, reward = 30, type = 'arroser'},
        {coords = vector3(-1240.56, -1475.12, 4.36), label = 'Arroser jardiniere', time = 5000, reward = 30, type = 'arroser'},
        -- Ramassage feuilles
        {coords = vector3(-1195.89, -1495.34, 4.36), label = 'Ramasser feuilles', time = 7000, reward = 38, type = 'ramasser'},
        {coords = vector3(-1198.12, -1492.56, 4.36), label = 'Ramasser feuilles', time = 7000, reward = 38, type = 'ramasser'},
        {coords = vector3(-1201.34, -1489.78, 4.36), label = 'Ratisser allee', time = 8000, reward = 42, type = 'ramasser'},
        -- Plantation
        {coords = vector3(-1205.78, -1490.45, 4.36), label = 'Planter fleurs', time = 10000, reward = 58, type = 'planter'},
        {coords = vector3(-1208.12, -1487.67, 4.36), label = 'Planter arbuste', time = 12000, reward = 65, type = 'planter'},
        {coords = vector3(-1175.78, -1510.12, 4.36), label = 'Planter bulbes', time = 8000, reward = 48, type = 'planter'},
    },

    animation = {
        tondre = {dict = 'amb@world_human_push_cart@male@idle_a', anim = 'idle_a', flag = 49}, -- Pousser tondeuse
        tailler = {dict = 'amb@world_human_gardener_leaf_blower@base', anim = 'base', flag = 49}, -- Mouvement taille
        arroser = {dict = 'amb@world_human_gardener_plant@male@base', anim = 'base', flag = 49}, -- Arrosoir
        ramasser = {dict = 'anim@move_m@trash', anim = 'pickup', flag = 49}, -- Ramasser
        planter = {dict = 'amb@world_human_gardener_plant@male@base', anim = 'base', flag = 49}, -- Planter
    },

    illegalMissions = {
        {id = 'garden_1', label = 'Enterrer magot', description = 'Enterrer un sac...', targetCoords = vector3(-1230.45, -1470.67, 4.36), reward = 700, time = 120000, xpBonus = 25},
        {id = 'garden_2', label = 'Deterrer planque', description = 'Recuperer un colis...', targetCoords = vector3(-1200.23, -1490.45, 4.36), reward = 1200, time = 150000, xpBonus = 45},
        {id = 'garden_3', label = 'Plantation speciale', description = 'Planter discretement...', targetCoords = vector3(-1245.67, -1460.12, 4.36), reward = 900, time = 130000, xpBonus = 35},
        {id = 'garden_4', label = 'Surveillance', description = 'Observer quelqu\'un...', targetCoords = vector3(-1215.34, -1480.78, 4.36), reward = 600, time = 100000, xpBonus = 20},
        {id = 'garden_5', label = 'Message cache', description = 'Deposer sous une pierre...', targetCoords = vector3(-1255.78, -1450.34, 4.36), reward = 500, time = 90000, xpBonus = 18},
        {id = 'garden_6', label = 'Rendez-vous', description = 'Rencontrer un contact...', targetCoords = vector3(-1190.12, -1500.56, 4.36), reward = 800, time = 130000, xpBonus = 30},
        {id = 'garden_7', label = 'Destruction', description = 'Bruler des documents...', targetCoords = vector3(-1235.45, -1465.89, 4.36), reward = 750, time = 110000, xpBonus = 28},
        {id = 'garden_8', label = 'Echange', description = 'Echanger un sac...', targetCoords = vector3(-1205.67, -1485.23, 4.36), reward = 950, time = 140000, xpBonus = 36},
        {id = 'garden_9', label = 'Fouille', description = 'Chercher objet cache...', targetCoords = vector3(-1260.34, -1448.67, 4.36), reward = 650, time = 100000, xpBonus = 22},
        {id = 'garden_10', label = 'Transport', description = 'Sortir dans brouette...', targetCoords = vector3(-1175.78, -1510.12, 4.36), reward = 1100, time = 160000, xpBonus = 42},
    },
}
