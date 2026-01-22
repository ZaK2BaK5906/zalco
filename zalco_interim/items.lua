-- =============================================================================
-- ZALCO INTERIM - ITEMS DEFINITIONS
-- Pour ox_inventory - Copier dans ox_inventory/data/items.lua
-- =============================================================================

return {
    -- =========================================================================
    -- MINEUR - Outils
    -- =========================================================================
    ['pickaxe'] = {
        label = 'Pickaxe',
        weight = 2000,
        stack = false,
        close = true,
        description = 'Une pioche pour extraire des minerais',
    },

    -- =========================================================================
    -- MINEUR - Minerais de base
    -- =========================================================================
    ['coal_ore'] = {
        label = 'Coal Ore',
        weight = 250,
        stack = true,
        close = true,
        description = 'Minerai de charbon extrait de la mine',
    },

    ['flint'] = {
        label = 'Flint',
        weight = 150,
        stack = true,
        close = true,
        description = 'Pierre de silex',
    },

    ['sulfur_chunk'] = {
        label = 'Sulfur Chunk',
        weight = 200,
        stack = true,
        close = true,
        description = 'Morceau de soufre brut',
    },

    -- =========================================================================
    -- MINEUR - Or
    -- =========================================================================
    ['gold_nugget'] = {
        label = 'Gold Nugget',
        weight = 250,
        stack = true,
        close = true,
        description = 'Pepite d\'or precieuse',
    },

    ['gold_dust'] = {
        label = 'Gold Dust',
        weight = 150,
        stack = true,
        close = true,
        description = 'Poussiere d\'or',
    },

    -- =========================================================================
    -- MINEUR - Cristaux communs
    -- =========================================================================
    ['quartz_crystal'] = {
        label = 'Quartz Crystal',
        weight = 200,
        stack = true,
        close = true,
        description = 'Cristal de quartz pur',
    },

    ['emerald_crystal'] = {
        label = 'Emerald Crystal',
        weight = 250,
        stack = true,
        close = true,
        description = 'Cristal d\'emeraude brut',
    },

    ['beryl_chunk'] = {
        label = 'Beryl Chunk',
        weight = 200,
        stack = true,
        close = true,
        description = 'Morceau de beryl',
    },

    ['green_garnet'] = {
        label = 'Green Garnet',
        weight = 150,
        stack = true,
        close = true,
        description = 'Grenat vert rare',
    },

    -- =========================================================================
    -- MINEUR - Pierres precieuses
    -- =========================================================================
    ['ruby_crystal'] = {
        label = 'Ruby Crystal',
        weight = 250,
        stack = true,
        close = true,
        description = 'Cristal de rubis brut',
    },

    ['corundum_chunk'] = {
        label = 'Corundum Chunk',
        weight = 200,
        stack = true,
        close = true,
        description = 'Morceau de corindon',
    },

    ['pink_sapphire'] = {
        label = 'Pink Sapphire',
        weight = 150,
        stack = true,
        close = true,
        description = 'Saphir rose precieux',
    },

    -- =========================================================================
    -- MINEUR - Amethyste et quartz
    -- =========================================================================
    ['amethyst_geode'] = {
        label = 'Amethyst Geode',
        weight = 250,
        stack = true,
        close = true,
        description = 'Geode d\'amethyste',
    },

    ['purple_quartz'] = {
        label = 'Purple Quartz',
        weight = 200,
        stack = true,
        close = true,
        description = 'Quartz violet',
    },

    ['clear_crystal'] = {
        label = 'Clear Crystal',
        weight = 150,
        stack = true,
        close = true,
        description = 'Cristal pur transparent',
    },

    -- =========================================================================
    -- MINEUR - Diamants
    -- =========================================================================
    ['diamond_crystal'] = {
        label = 'Diamond Crystal',
        weight = 250,
        stack = true,
        close = true,
        description = 'Diamant brut de grande valeur',
    },

    ['graphite_chunk'] = {
        label = 'Graphite Chunk',
        weight = 200,
        stack = true,
        close = true,
        description = 'Morceau de graphite',
    },

    ['blue_diamond'] = {
        label = 'Blue Diamond',
        weight = 150,
        stack = true,
        close = true,
        description = 'Diamant bleu extremement rare',
    },

    -- =========================================================================
    -- BUCHERON - Haches
    -- =========================================================================
    ['axe_rusty'] = {
        label = 'Rusty Axe',
        weight = 8000,
        stack = false,
        close = true,
        description = 'Une vieille hache rouillee mais fonctionnelle',
        client = {
            export = 'qs-lumberjack.toggleAxe'
        },
        server = {
            export = 'qs-lumberjack.axe'
        },
    },

    ['axe_iron'] = {
        label = 'Iron-Edged Axe',
        weight = 8000,
        stack = false,
        close = true,
        description = 'Hache avec lame en fer de qualite',
        client = {
            export = 'qs-lumberjack.toggleAxe'
        },
        server = {
            export = 'qs-lumberjack.axe'
        },
    },

    ['axe_mythical'] = {
        label = 'Mythical Axe',
        weight = 8000,
        stack = false,
        close = true,
        description = 'Hache legendaire de grande puissance',
        client = {
            export = 'qs-lumberjack.toggleAxe'
        },
        server = {
            export = 'qs-lumberjack.axe'
        },
    },

    -- =========================================================================
    -- BUCHERON - Bois
    -- =========================================================================
    ['wood_log'] = {
        label = 'Wood Log',
        weight = 1000,
        stack = true,
        close = true,
        description = 'Buche de bois fraichement coupee',
    },

    -- =========================================================================
    -- BOUCHER - Viandes
    -- =========================================================================
    ['meat_beef'] = {
        label = 'Beef Meat',
        weight = 500,
        stack = true,
        close = true,
        description = 'Viande de boeuf crue',
    },

    ['meat_pork'] = {
        label = 'Pork Meat',
        weight = 450,
        stack = true,
        close = true,
        description = 'Viande de porc crue',
    },

    ['meat_chicken'] = {
        label = 'Chicken Meat',
        weight = 300,
        stack = true,
        close = true,
        description = 'Viande de poulet crue',
    },

    ['meat_lamb'] = {
        label = 'Lamb Meat',
        weight = 400,
        stack = true,
        close = true,
        description = 'Viande d\'agneau crue',
    },

    ['raw_leather'] = {
        label = 'Raw Leather',
        weight = 600,
        stack = true,
        close = true,
        description = 'Cuir brut non traite',
    },

    ['meat_beef_cut'] = {
        label = 'Beef Cuts',
        weight = 350,
        stack = true,
        close = true,
        description = 'Morceaux de boeuf decoupes',
    },

    ['meat_pork_cut'] = {
        label = 'Pork Cuts',
        weight = 300,
        stack = true,
        close = true,
        description = 'Morceaux de porc decoupes',
    },

    ['meat_packed'] = {
        label = 'Packed Meat',
        weight = 400,
        stack = true,
        close = true,
        description = 'Viande emballee prete a vendre',
    },

    ['butcher_knife'] = {
        label = 'Butcher Knife',
        weight = 500,
        stack = false,
        close = true,
        description = 'Couteau de boucher professionnel',
    },

    -- =========================================================================
    -- JARDINIER - Outils
    -- =========================================================================
    ['garden_shears'] = {
        label = 'Garden Shears',
        weight = 800,
        stack = false,
        close = true,
        description = 'Secateur pour tailler les haies',
    },

    ['garden_rake'] = {
        label = 'Garden Rake',
        weight = 1200,
        stack = false,
        close = true,
        description = 'Rateau pour ramasser les feuilles',
    },
}
