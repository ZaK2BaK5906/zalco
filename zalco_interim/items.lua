-- =============================================================================
-- ZALCO INTERIM - ITEMS DEFINITIONS
-- Pour ox_inventory - Copier dans ox_inventory/data/items.lua
-- =============================================================================

return {
    -- =========================================================================
    -- MINEUR - Minerais
    -- =========================================================================
    ['charbon'] = {
        label = 'Charbon',
        weight = 500,
        stack = true,
        close = true,
        description = 'Morceau de charbon extrait de la mine',
        client = {
            image = 'charbon.png',
        }
    },

    ['minerai_fer'] = {
        label = 'Minerai de Fer',
        weight = 800,
        stack = true,
        close = true,
        description = 'Minerai de fer brut, peut etre fondu',
        client = {
            image = 'minerai_fer.png',
        }
    },

    ['minerai_or'] = {
        label = 'Minerai d\'Or',
        weight = 1000,
        stack = true,
        close = true,
        description = 'Precieux minerai d\'or brut',
        client = {
            image = 'minerai_or.png',
        }
    },

    ['diamant_brut'] = {
        label = 'Diamant Brut',
        weight = 200,
        stack = true,
        close = true,
        description = 'Diamant non taille, tres precieux',
        client = {
            image = 'diamant_brut.png',
        }
    },

    -- =========================================================================
    -- BUCHERON - Bois
    -- =========================================================================
    ['bois_brut'] = {
        label = 'Bois Brut',
        weight = 1000,
        stack = true,
        close = true,
        description = 'Buche de bois fraichement coupee',
        client = {
            image = 'bois_brut.png',
        }
    },

    ['ecorce'] = {
        label = 'Ecorce',
        weight = 200,
        stack = true,
        close = true,
        description = 'Ecorce d\'arbre, utilisable en artisanat',
        client = {
            image = 'ecorce.png',
        }
    },

    ['resine'] = {
        label = 'Resine',
        weight = 300,
        stack = true,
        close = true,
        description = 'Resine d\'arbre naturelle',
        client = {
            image = 'resine.png',
        }
    },

    -- =========================================================================
    -- BOUCHER - Viandes
    -- =========================================================================
    ['viande_boeuf'] = {
        label = 'Viande de Boeuf',
        weight = 500,
        stack = true,
        close = true,
        description = 'Morceau de viande de boeuf crue',
        client = {
            image = 'viande_boeuf.png',
        }
    },

    ['viande_porc'] = {
        label = 'Viande de Porc',
        weight = 450,
        stack = true,
        close = true,
        description = 'Morceau de viande de porc crue',
        client = {
            image = 'viande_porc.png',
        }
    },

    ['viande_poulet'] = {
        label = 'Viande de Poulet',
        weight = 300,
        stack = true,
        close = true,
        description = 'Morceau de viande de poulet crue',
        client = {
            image = 'viande_poulet.png',
        }
    },

    ['viande_agneau'] = {
        label = 'Viande d\'Agneau',
        weight = 400,
        stack = true,
        close = true,
        description = 'Morceau de viande d\'agneau crue',
        client = {
            image = 'viande_agneau.png',
        }
    },

    ['cuir_brut'] = {
        label = 'Cuir Brut',
        weight = 600,
        stack = true,
        close = true,
        description = 'Peau d\'animal non traitee',
        client = {
            image = 'cuir_brut.png',
        }
    },
}
