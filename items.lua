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
-- BEER (BIÈRE)
-- ============================================
['beer_low'] = {
    label = 'Bière (Mauvaise qualité)',
    weight = 500,
    stack = true,
    close = true,
    description = 'Bière artisanale de mauvaise qualité - Prix de vente: ~120$',
    client = {
        image = 'beer_low.png'
    }
},

['beer_mid'] = {
    label = 'Bière (Qualité moyenne)',
    weight = 500,
    stack = true,
    close = true,
    description = 'Bière artisanale de qualité moyenne - Prix de vente: ~250$',
    client = {
        image = 'beer_mid.png'
    }
},

['beer_high'] = {
    label = 'Bière (Bonne qualité)',
    weight = 500,
    stack = true,
    close = true,
    description = 'Bière artisanale de bonne qualité - Prix de vente: ~420$',
    client = {
        image = 'beer_high.png'
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
-- SAKE (SAKÉ)
-- ============================================
['sake_low'] = {
    label = 'Sake (Mauvaise qualité)',
    weight = 750,
    stack = true,
    close = true,
    description = 'Sake artisanal de mauvaise qualité - Prix de vente: ~200$',
    client = {
        image = 'sake_low.png'
    }
},

['sake_mid'] = {
    label = 'Sake (Qualité moyenne)',
    weight = 750,
    stack = true,
    close = true,
    description = 'Sake artisanal de qualité moyenne - Prix de vente: ~400$',
    client = {
        image = 'sake_mid.png'
    }
},

['sake_high'] = {
    label = 'Sake (Bonne qualité)',
    weight = 750,
    stack = true,
    close = true,
    description = 'Sake artisanal de bonne qualité - Prix de vente: ~650$',
    client = {
        image = 'sake_high.png'
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

