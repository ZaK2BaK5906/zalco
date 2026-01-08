# 🚀 Démarrage Rapide - Zalco

## ⚡ Installer en 3 étapes

### 1️⃣ Installation
```bash
1. Copier le dossier 'zalco' dans resources/[local]/
2. Exécuter zalco.sql dans votre base de données
3. Ajouter le contenu de items.lua dans ox_inventory/data/items.lua
4. Ajouter 'ensure zalco' dans server.cfg
5. Redémarrer le serveur
```

### 2️⃣ Donner la tablette à un joueur
```lua
/giveitem [id] alcohol_tablet 1
/giveitem [id] empty_bottle 10
```

### 3️⃣ Tester
```bash
1. Se téléporter à un point de farming : /tp 1905.14 4925.43 48.86
2. Farmer de la levure
3. Aller au labo : /tp -131.18 6366.42 31.48
4. Produire de l'alcool
5. Vendre chez un receleur : /tp 932.31 -2355.74 30.58
```

---

## 🎮 Commandes Utiles

### Admin
```lua
-- Donner la tablette
/giveitem [id] alcohol_tablet 1

-- Donner des bouteilles vides
/giveitem [id] empty_bottle 20

-- Donner des ingrédients (test)
/giveitem [id] levure 10
/giveitem [id] eau_source 10
/giveitem [id] sucre 10

-- Donner de l'alcool (test vente)
/giveitem [id] vodka_low 5
/giveitem [id] cognac_high 2
```

### Téléportations
```lua
-- Points de farming
/tp 1905.14 4925.43 48.86    # Levure 1
/tp 2229.23 5577.13 53.85    # Levure 2
/tp -1361.29 4427.94 35.47   # Eau 1
/tp 2210.37 5577.81 53.85    # Sucre 1
/tp 1989.56 4951.52 41.87    # Raisin

-- Laboratoires
/tp -131.18 6366.42 31.48    # Labo 1
/tp 1905.69 4931.72 48.86    # Labo 2

-- Vendeurs
/tp 932.31 -2355.74 30.58    # Receleur 1
/tp 1961.95 3740.48 32.34    # Receleur 2
/tp -770.14 5594.21 33.49    # Receleur 3
```

---

## 📊 Système de Progression

### Niveaux
- **Niveau 0** (0 XP) : Vodka, Pastis
- **Niveau 1** (50 XP) : Whisky, Gin, Rhum
- **Niveau 2** (150 XP) : Tequila, Calvados
- **Niveau 3** (300 XP) : Moonshine, Absinthe
- **Niveau 4** (500 XP) : Cognac

### Gagner de l'XP
- Farming : 1 XP par item
- Production : 5 XP par alcool
- Vente : 10 XP par alcool

---

## 💰 Prix de Vente

### Qualité Mauvaise
- Pastis : ~140$ | Vodka : ~150$ | Calvados : ~160$
- Gin : ~170$ | Rhum : ~180$ | Tequila : ~190$
- Whisky : ~200$ | Moonshine : ~220$ | Absinthe : ~250$
- Cognac : ~280$

### Qualité Moyenne
- Pastis : ~280$ | Vodka : ~300$ | Calvados : ~310$
- Gin : ~320$ | Rhum : ~350$ | Tequila : ~370$
- Whisky : ~400$ | Moonshine : ~450$ | Absinthe : ~500$
- Cognac : ~550$

### Qualité Bonne
- Pastis : ~450$ | Vodka : ~500$ | Calvados : ~510$
- Gin : ~520$ | Rhum : ~550$ | Tequila : ~580$
- Whisky : ~650$ | Moonshine : ~700$ | Absinthe : ~800$
- Cognac : ~900$

> 💡 **Note** : Les prix varient de -20% à +30% à chaque vente

---

## 🧪 Recettes Principales

### Vodka (Niveau 0)
- **Mauvaise** : 2 levure + 3 eau + 1 sucre
- **Moyenne** : 3 levure + 4 eau + 2 sucre
- **Bonne** : 4 levure + 5 eau + 3 sucre

### Whisky (Niveau 1)
- **Mauvaise** : 2 levure + 4 orge + 2 eau
- **Moyenne** : 3 levure + 6 orge + 3 eau
- **Bonne** : 4 levure + 8 orge + 4 eau

### Cognac (Niveau 4)
- **Mauvaise** : 3 levure + 8 raisin + 3 eau
- **Moyenne** : 4 levure + 12 raisin + 4 eau
- **Bonne** : 5 levure + 16 raisin + 5 eau

> 📖 Toutes les recettes dans le README.md

---

## 🔧 Configuration Rapide

### Activer les blips
```lua
-- Dans config/config.lua
Config.Labs[1].blip.enabled = true
Config.Sellers[1].blip.enabled = true
```

### Changer les temps
```lua
Config.FarmingTime = 3000       -- 3 secondes au lieu de 5
Config.ProcessingTime = 7000    -- 7 secondes au lieu de 10
Config.DistillationTime = 10000 -- 10 secondes au lieu de 15
```

### Augmenter les récompenses
```lua
-- Points de farming : modifier amount
amount = {min = 3, max = 7}  -- Au lieu de {min = 1, max = 3}

-- XP : modifier Config.Experience
Config.Experience = {
    farming = 2,     -- Au lieu de 1
    processing = 10, -- Au lieu de 5
    selling = 20     -- Au lieu de 10
}
```

---

## ✅ Checklist Post-Installation

- [ ] Base de données créée (table alcohol_stats)
- [ ] Items ajoutés dans ox_inventory
- [ ] Script démarré (ensure zalco)
- [ ] Tablette fonctionnelle
- [ ] Farming fonctionne
- [ ] Laboratoire s'ouvre
- [ ] Production d'alcool fonctionne
- [ ] Vente fonctionne
- [ ] Stats se sauvegardent

---

## 🐛 Problème ?

1. **F8** → Vérifier les erreurs
2. **Console serveur** → Vérifier les logs
3. **ox_inventory redémarré ?** → `restart ox_inventory`
4. **Table créée ?** → Vérifier dans phpMyAdmin
5. **Items ajoutés ?** → Vérifier ox_inventory/data/items.lua

---

## 📚 Documentation Complète

- **README.md** : Documentation complète
- **INSTALLATION.md** : Guide d'installation détaillé
- **CHANGELOG.md** : Historique des versions

---

**Bon farming ! 🍺💰**
