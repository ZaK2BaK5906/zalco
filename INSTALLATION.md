# 📦 Guide d'Installation Rapide - Zalco

## ⚡ Installation en 5 minutes

### Étape 1 : Copier les fichiers
```bash
# Placer le dossier 'zalco' dans votre dossier resources
resources/[local]/zalco/
```

### Étape 2 : Importer la base de données
Exécuter le fichier `zalco.sql` dans votre base de données MySQL :
```bash
# Via phpMyAdmin : Importer le fichier zalco.sql
# OU via console MySQL :
mysql -u votre_user -p votre_database < zalco.sql
```

### Étape 3 : Ajouter les items à ox_inventory

1. Ouvrir le fichier `ox_inventory/data/items.lua`
2. Copier-coller **TOUT** le contenu du fichier `items.lua` fourni
3. Sauvegarder le fichier

> ⚠️ **IMPORTANT** : Ne pas oublier les virgules entre les items !

### Étape 4 : Ajouter au server.cfg
```cfg
ensure zalco
```

### Étape 5 : Redémarrer le serveur
```bash
# Redémarrer complètement le serveur OU :
restart ox_inventory
ensure zalco
```

---

## ✅ Vérification de l'installation

### Test 1 : Vérifier les items
```lua
/giveitem [votre_id] alcohol_tablet 1
/giveitem [votre_id] empty_bottle 5
```
Si vous recevez les items, l'installation des items est OK ✅

### Test 2 : Tester le farming
1. Se téléporter à un point de farming : `/tp 1905.14 4925.43 48.86`
2. Interagir avec le point (E ou ox_target)
3. Vous devriez récolter de la levure ✅

### Test 3 : Tester le laboratoire
1. Se téléporter au labo : `/tp -131.18 6366.42 31.48`
2. Ouvrir le menu du laboratoire
3. L'UI devrait s'afficher ✅

### Test 4 : Utiliser la tablette
1. Utiliser l'item `alcohol_tablet` depuis votre inventaire
2. Vos statistiques devraient s'afficher ✅

---

## 🔧 Configuration de Base

### Activer les blips (optionnel)
Dans `config/config.lua`, modifier :
```lua
-- Pour les labos
Config.Labs = {
    {
        blip = {
            enabled = true,  -- Mettre à true
            -- ...
        }
    }
}

-- Pour les vendeurs
Config.Sellers = {
    {
        blip = {
            enabled = true,  -- Mettre à true
            -- ...
        }
    }
}
```

### Utiliser les markers au lieu de ox_target
Si vous n'avez pas ox_target, modifier :
```lua
Config.UseTarget = false
```

### Ajuster les temps de farming/distillation
```lua
Config.FarmingTime = 5000      -- 5 secondes (en millisecondes)
Config.ProcessingTime = 10000  -- 10 secondes
Config.DistillationTime = 15000 -- 15 secondes
```

### Modifier les prix de vente
Dans `config/config.lua`, section `Config.AlcoholTypes` :
```lua
{quality = 'mauvaise', item = 'vodka_low', sellPrice = 150, -- Modifier ici
```

---

## 🎁 Donner des Items aux Joueurs

### Items de démarrage
```lua
/giveitem [id] alcohol_tablet 1     -- Tablette de stats
/giveitem [id] empty_bottle 10      -- Bouteilles vides
```

### Ingrédients (pour tester)
```lua
/giveitem [id] levure 10
/giveitem [id] eau_source 10
/giveitem [id] sucre 10
/giveitem [id] raisin 10
/giveitem [id] pomme 10
/giveitem [id] mais 10
/giveitem [id] orge 10
```

### Alcools (pour tester la vente)
```lua
/giveitem [id] vodka_low 5
/giveitem [id] whisky_mid 3
/giveitem [id] cognac_high 1
```

---

## 🐛 Problèmes Courants

### ❌ Les items n'apparaissent pas
**Solution** : Vérifier que vous avez bien ajouté tous les items dans `ox_inventory/data/items.lua` et redémarré ox_inventory.

### ❌ L'UI ne s'ouvre pas
**Solution** : Vérifier la console F8 pour les erreurs. S'assurer que ox_lib est bien installé et démarré.

### ❌ Les stats ne se sauvegardent pas
**Solution** : Vérifier que la table `alcohol_stats` a bien été créée dans la base de données.

### ❌ Les PNJ ne spawent pas
**Solution** : Vérifier les coordonnées dans la config. Essayer de se téléporter aux coordonnées pour vérifier qu'elles sont valides.

### ❌ "attempt to call a nil value (field 'callback')"
**Solution** : S'assurer que ox_lib est à jour et bien installé.

---

## 📊 Liste Complète des Items

### Items de base (2)
- `empty_bottle` - Bouteille vide
- `alcohol_tablet` - Tablette de contrebande

### Ingrédients (7)
- `levure` - Levure
- `eau_source` - Eau de source
- `sucre` - Sucre
- `raisin` - Raisin
- `pomme` - Pomme
- `mais` - Maïs
- `orge` - Orge

### Alcools (30)
**Vodka (3)** : `vodka_low`, `vodka_mid`, `vodka_high`
**Whisky (3)** : `whisky_low`, `whisky_mid`, `whisky_high`
**Rhum (3)** : `rhum_low`, `rhum_mid`, `rhum_high`
**Gin (3)** : `gin_low`, `gin_mid`, `gin_high`
**Tequila (3)** : `tequila_low`, `tequila_mid`, `tequila_high`
**Calvados (3)** : `calvados_low`, `calvados_mid`, `calvados_high`
**Moonshine (3)** : `moonshine_low`, `moonshine_mid`, `moonshine_high`
**Absinthe (3)** : `absinthe_low`, `absinthe_mid`, `absinthe_high`
**Cognac (3)** : `cognac_low`, `cognac_mid`, `cognac_high`
**Pastis (3)** : `pastis_low`, `pastis_mid`, `pastis_high`

**TOTAL : 39 items**

---

## 🚀 C'est tout !

Votre script est maintenant installé et fonctionnel !

Pour toute question, consulter le README.md principal.

**Bon jeu ! 🍺**
