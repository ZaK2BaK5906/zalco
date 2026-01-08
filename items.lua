-- ============================================
-- ITEMS POUR OX_INVENTORY
-- À ajouter dans ox_inventory/data/items.lua
-- ============================================

-- Items de base
['empty_bottle'] = {
    label = 'Bouteille vide',
    weight = 100,
    stack = true,
    close = true,
    description = 'Une bouteille vide pour récolter des ingrédients'
},

['alcohol_tablet'] = {
    label = 'Tablette de contrebande',
    weight = 500,
    stack = false,
    close = true,
    description = 'Tablette pour suivre vos statistiques de contrebande',
    client = {
        export = 'zalco.alcohol_tablet'
    }
},

-- Ingrédients
['levure'] = {
    label = 'Levure',
    weight = 50,
    stack = true,
    close = true,
    description = 'Levure de brassage pour la fermentation'
},

['eau_source'] = {
    label = 'Eau de source',
    weight = 200,
    stack = true,
    close = true,
    description = 'Eau pure de source naturelle'
},

['sucre'] = {
    label = 'Sucre',
    weight = 100,
    stack = true,
    close = true,
    description = 'Sucre de canne raffiné'
},

['raisin'] = {
    label = 'Raisin',
    weight = 150,
    stack = true,
    close = true,
    description = 'Grappes de raisin frais'
},

['pomme'] = {
    label = 'Pomme',
    weight = 120,
    stack = true,
    close = true,
    description = 'Pommes fraîches'
},

['mais'] = {
    label = 'Maïs',
    weight = 130,
    stack = true,
    close = true,
    description = 'Épis de maïs'
},

['orge'] = {
    label = 'Orge',
    weight = 140,
    stack = true,
    close = true,
    description = 'Grains d\'orge'
},

-- ============================================
-- VODKA
-- ============================================
['vodka_low'] = {
    label = 'Vodka (Mauvaise qualité)',
    weight = 800,
    stack = true,
    close = true,
    description = 'Vodka artisanale de mauvaise qualité - Prix de vente: ~150$',
    client = {
        image = 'vodka_low.png'
    }
},

['vodka_mid'] = {
    label = 'Vodka (Qualité moyenne)',
    weight = 800,
    stack = true,
    close = true,
    description = 'Vodka artisanale de qualité moyenne - Prix de vente: ~300$',
    client = {
        image = 'vodka_mid.png'
    }
},

['vodka_high'] = {
    label = 'Vodka (Bonne qualité)',
    weight = 800,
    stack = true,
    close = true,
    description = 'Vodka artisanale de bonne qualité - Prix de vente: ~500$',
    client = {
        image = 'vodka_high.png'
    }
},

-- ============================================
-- WHISKY
-- ============================================
['whisky_low'] = {
    label = 'Whisky (Mauvaise qualité)',
    weight = 900,
    stack = true,
    close = true,
    description = 'Whisky artisanal de mauvaise qualité - Prix de vente: ~200$',
    client = {
        image = 'whisky_low.png'
    }
},

['whisky_mid'] = {
    label = 'Whisky (Qualité moyenne)',
    weight = 900,
    stack = true,
    close = true,
    description = 'Whisky artisanal de qualité moyenne - Prix de vente: ~400$',
    client = {
        image = 'whisky_mid.png'
    }
},

['whisky_high'] = {
    label = 'Whisky (Bonne qualité)',
    weight = 900,
    stack = true,
    close = true,
    description = 'Whisky artisanal de bonne qualité - Prix de vente: ~650$',
    client = {
        image = 'whisky_high.png'
    }
},

-- ============================================
-- RHUM
-- ============================================
['rhum_low'] = {
    label = 'Rhum (Mauvaise qualité)',
    weight = 850,
    stack = true,
    close = true,
    description = 'Rhum artisanal de mauvaise qualité - Prix de vente: ~180$',
    client = {
        image = 'rhum_low.png'
    }
},

['rhum_mid'] = {
    label = 'Rhum (Qualité moyenne)',
    weight = 850,
    stack = true,
    close = true,
    description = 'Rhum artisanal de qualité moyenne - Prix de vente: ~350$',
    client = {
        image = 'rhum_mid.png'
    }
},

['rhum_high'] = {
    label = 'Rhum (Bonne qualité)',
    weight = 850,
    stack = true,
    close = true,
    description = 'Rhum artisanal de bonne qualité - Prix de vente: ~550$',
    client = {
        image = 'rhum_high.png'
    }
},

-- ============================================
-- GIN
-- ============================================
['gin_low'] = {
    label = 'Gin (Mauvaise qualité)',
    weight = 820,
    stack = true,
    close = true,
    description = 'Gin artisanal de mauvaise qualité - Prix de vente: ~170$',
    client = {
        image = 'gin_low.png'
    }
},

['gin_mid'] = {
    label = 'Gin (Qualité moyenne)',
    weight = 820,
    stack = true,
    close = true,
    description = 'Gin artisanal de qualité moyenne - Prix de vente: ~320$',
    client = {
        image = 'gin_mid.png'
    }
},

['gin_high'] = {
    label = 'Gin (Bonne qualité)',
    weight = 820,
    stack = true,
    close = true,
    description = 'Gin artisanal de bonne qualité - Prix de vente: ~520$',
    client = {
        image = 'gin_high.png'
    }
},

-- ============================================
-- TEQUILA
-- ============================================
['tequila_low'] = {
    label = 'Tequila (Mauvaise qualité)',
    weight = 880,
    stack = true,
    close = true,
    description = 'Tequila artisanale de mauvaise qualité - Prix de vente: ~190$',
    client = {
        image = 'tequila_low.png'
    }
},

['tequila_mid'] = {
    label = 'Tequila (Qualité moyenne)',
    weight = 880,
    stack = true,
    close = true,
    description = 'Tequila artisanale de qualité moyenne - Prix de vente: ~370$',
    client = {
        image = 'tequila_mid.png'
    }
},

['tequila_high'] = {
    label = 'Tequila (Bonne qualité)',
    weight = 880,
    stack = true,
    close = true,
    description = 'Tequila artisanale de bonne qualité - Prix de vente: ~580$',
    client = {
        image = 'tequila_high.png'
    }
},

-- ============================================
-- CALVADOS
-- ============================================
['calvados_low'] = {
    label = 'Calvados (Mauvaise qualité)',
    weight = 860,
    stack = true,
    close = true,
    description = 'Calvados artisanal de mauvaise qualité - Prix de vente: ~160$',
    client = {
        image = 'calvados_low.png'
    }
},

['calvados_mid'] = {
    label = 'Calvados (Qualité moyenne)',
    weight = 860,
    stack = true,
    close = true,
    description = 'Calvados artisanal de qualité moyenne - Prix de vente: ~310$',
    client = {
        image = 'calvados_mid.png'
    }
},

['calvados_high'] = {
    label = 'Calvados (Bonne qualité)',
    weight = 860,
    stack = true,
    close = true,
    description = 'Calvados artisanal de bonne qualité - Prix de vente: ~510$',
    client = {
        image = 'calvados_high.png'
    }
},

-- ============================================
-- MOONSHINE
-- ============================================
['moonshine_low'] = {
    label = 'Moonshine (Mauvaise qualité)',
    weight = 950,
    stack = true,
    close = true,
    description = 'Moonshine artisanal de mauvaise qualité - Prix de vente: ~220$',
    client = {
        image = 'moonshine_low.png'
    }
},

['moonshine_mid'] = {
    label = 'Moonshine (Qualité moyenne)',
    weight = 950,
    stack = true,
    close = true,
    description = 'Moonshine artisanal de qualité moyenne - Prix de vente: ~450$',
    client = {
        image = 'moonshine_mid.png'
    }
},

['moonshine_high'] = {
    label = 'Moonshine (Bonne qualité)',
    weight = 950,
    stack = true,
    close = true,
    description = 'Moonshine artisanal de bonne qualité - Prix de vente: ~700$',
    client = {
        image = 'moonshine_high.png'
    }
},

-- ============================================
-- ABSINTHE
-- ============================================
['absinthe_low'] = {
    label = 'Absinthe (Mauvaise qualité)',
    weight = 920,
    stack = true,
    close = true,
    description = 'Absinthe artisanale de mauvaise qualité - Prix de vente: ~250$',
    client = {
        image = 'absinthe_low.png'
    }
},

['absinthe_mid'] = {
    label = 'Absinthe (Qualité moyenne)',
    weight = 920,
    stack = true,
    close = true,
    description = 'Absinthe artisanale de qualité moyenne - Prix de vente: ~500$',
    client = {
        image = 'absinthe_mid.png'
    }
},

['absinthe_high'] = {
    label = 'Absinthe (Bonne qualité)',
    weight = 920,
    stack = true,
    close = true,
    description = 'Absinthe artisanale de bonne qualité - Prix de vente: ~800$',
    client = {
        image = 'absinthe_high.png'
    }
},

-- ============================================
-- COGNAC
-- ============================================
['cognac_low'] = {
    label = 'Cognac (Mauvaise qualité)',
    weight = 1000,
    stack = true,
    close = true,
    description = 'Cognac artisanal de mauvaise qualité - Prix de vente: ~280$',
    client = {
        image = 'cognac_low.png'
    }
},

['cognac_mid'] = {
    label = 'Cognac (Qualité moyenne)',
    weight = 1000,
    stack = true,
    close = true,
    description = 'Cognac artisanal de qualité moyenne - Prix de vente: ~550$',
    client = {
        image = 'cognac_mid.png'
    }
},

['cognac_high'] = {
    label = 'Cognac (Bonne qualité)',
    weight = 1000,
    stack = true,
    close = true,
    description = 'Cognac artisanal de bonne qualité - Prix de vente: ~900$',
    client = {
        image = 'cognac_high.png'
    }
},

-- ============================================
-- PASTIS
-- ============================================
['pastis_low'] = {
    label = 'Pastis (Mauvaise qualité)',
    weight = 750,
    stack = true,
    close = true,
    description = 'Pastis artisanal de mauvaise qualité - Prix de vente: ~140$',
    client = {
        image = 'pastis_low.png'
    }
},

['pastis_mid'] = {
    label = 'Pastis (Qualité moyenne)',
    weight = 750,
    stack = true,
    close = true,
    description = 'Pastis artisanal de qualité moyenne - Prix de vente: ~280$',
    client = {
        image = 'pastis_mid.png'
    }
},

['pastis_high'] = {
    label = 'Pastis (Bonne qualité)',
    weight = 750,
    stack = true,
    close = true,
    description = 'Pastis artisanal de bonne qualité - Prix de vente: ~450$',
    client = {
        image = 'pastis_high.png'
    }
},
