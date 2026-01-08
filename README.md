# 🍺 Zalco - Système de Contrebande d'Alcool

Script complet de contrebande d'alcool pour FiveM avec farming, transformation et vente pour serveurs ESX avec ox_inventory.

## ✨ Fonctionnalités

### 🌾 Système de Farming
- **4 points de récolte pour la levure** répartis sur la carte
- **2 points pour l'eau de source**
- **2 points pour le sucre (canne à sucre)**
- **Points pour les fruits** : raisin, pomme, maïs, orge
- Système d'animation pendant la récolte
- Quantités aléatoires (min/max configurables)

### 🧪 Laboratoires Clandestins
- **2 laboratoires secrets** pour la distillation
- Menu UI personnalisé pour la production
- Vérification des ingrédients en temps réel
- Animations de distillation
- Système de niveau requis pour débloquer les recettes

### 🍾 10 Types d'Alcool avec 3 Qualités chacun
Chaque type d'alcool peut être produit en 3 qualités différentes :

1. **Vodka** - Prix: 150$ / 300$ / 500$
2. **Whisky** - Prix: 200$ / 400$ / 650$
3. **Rhum** - Prix: 180$ / 350$ / 550$
4. **Gin** - Prix: 170$ / 320$ / 520$
5. **Tequila** - Prix: 190$ / 370$ / 580$
6. **Calvados** - Prix: 160$ / 310$ / 510$
7. **Moonshine** - Prix: 220$ / 450$ / 700$
8. **Absinthe** - Prix: 250$ / 500$ / 800$
9. **Cognac** - Prix: 280$ / 550$ / 900$
10. **Pastis** - Prix: 140$ / 280$ / 450$

### 💰 Système de Vente aux PNJ dans la Rue
- **Vente directe aux piétons** avec ox_target
- **Catégories de PNJ** : Business (riches), Gangs, SDF, Default
- **Prix variables selon la catégorie** :
  - Business : 100% à 150% du prix (argent propre)
  - Gangs : 80% à 120% du prix (argent sale)
  - SDF : 40% à 70% du prix (argent sale)
  - Défaut : 70% à 100% du prix (argent propre)
- **Système de refus** :
  - Business : 60% de refus
  - Gangs : 10% de refus
  - SDF : 5% de refus
  - Défaut : 30% de refus
- **Risque d'appel police** (5% à 15% selon le PNJ)
- **Zones interdites** (commissariats) avec alertes police
- **Cooldowns** : 10s entre ventes, 1min par PNJ
- **PNJ blacklistés** (flics, sécurité, etc.)
- Vente d'**1 seul alcool** à la fois (aléatoire)
- Reçu de vente détaillé avec UI custom

### 📊 Système de Statistiques
- **Tablette de contrebande** pour suivre les performances
- Expérience et niveaux
- Statistiques détaillées : items farmés, alcools produits, ventes
- Historique des items farmés par type
- Système de progression avec recettes à débloquer

### 🎨 Interface Utilisateur
- UI moderne et responsive
- Animations fluides
- Design sombre avec thème violet/bleu
- Compatible avec tous les écrans
- Icons Font Awesome

### 🔐 Système de Niveaux
- **5 niveaux de progression** :
  - Niveau 0 (Débutant) : Vodka, Pastis
  - Niveau 1 (Apprenti) : Whisky, Gin, Rhum
  - Niveau 2 (Distillateur) : Tequila, Calvados
  - Niveau 3 (Maître) : Moonshine, Absinthe
  - Niveau 4 (Légende) : Cognac

## 📋 Prérequis

- **ESX Legacy** (ou ESX 1.2+)
- **ox_inventory**
- **ox_lib**
- **oxmysql**
- **ox_target** (optionnel, peut utiliser les markers)

## 🚀 Installation

### 1. Télécharger et extraire
```bash
# Placer le dossier 'zalco' dans votre dossier resources
resources/[local]/zalco/
```

### 2. Ajouter les items à ox_inventory
Ouvrir `ox_inventory/data/items.lua` et ajouter tous les items du fichier `items.lua` fourni.

### 3. Créer la table MySQL
La table sera créée automatiquement au démarrage du script, mais vous pouvez aussi l'exécuter manuellement :

```sql
CREATE TABLE IF NOT EXISTS `alcohol_stats` (
    `identifier` VARCHAR(60) PRIMARY KEY,
    `experience` INT DEFAULT 0,
    `level` INT DEFAULT 0,
    `total_farmed` INT DEFAULT 0,
    `total_processed` INT DEFAULT 0,
    `total_sold` INT DEFAULT 0,
    `money_earned` INT DEFAULT 0,
    `farmed_items` TEXT DEFAULT '{}',
    `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### 4. Ajouter au server.cfg
```cfg
ensure zalco
```

### 5. Donner la tablette à un joueur (Admin)
```lua
/giveitem [id] alcohol_tablet 1
```

## ⚙️ Configuration

Tout est configurable dans `config/config.lua` :

### Temps de farming/transformation
```lua
Config.FarmingTime = 5000      -- 5 secondes
Config.ProcessingTime = 10000  -- 10 secondes
Config.DistillationTime = 15000 -- 15 secondes
```

### Points de farming
Vous pouvez modifier les coordonnées, les quantités, etc.
```lua
Config.FarmingPoints = {
    {
        type = 'levure',
        coords = vector3(x, y, z),
        item = 'levure',
        amount = {min = 1, max = 3},
        -- ...
    }
}
```

### Laboratoires
```lua
Config.Labs = {
    {
        name = 'Labo #1',
        coords = vector3(x, y, z),
        -- ...
    }
}
```

### Prix et qualités
Modifier les prix de vente et les ingrédients requis :
```lua
Config.AlcoholTypes = {
    {
        name = 'Vodka',
        qualities = {
            {quality = 'mauvaise', item = 'vodka_low', sellPrice = 150, ingredients = {...}}
        }
    }
}
```

## 🎮 Utilisation

### Pour les Joueurs

1. **Récolter des ingrédients**
   - Se rendre à un point de farming (levure, eau, sucre, fruits)
   - Interagir avec le point (E ou ox_target)
   - Attendre la fin de la récolte

2. **Distiller l'alcool**
   - Se rendre à un laboratoire clandestin
   - Ouvrir le menu du labo
   - Choisir le type d'alcool et la qualité
   - Avoir les ingrédients nécessaires
   - Lancer la distillation

3. **Vendre l'alcool**
   - Se rendre chez un receleur
   - Interagir avec le PNJ
   - Tous les alcools seront vendus automatiquement
   - Recevoir l'argent sale

4. **Consulter les stats**
   - Utiliser la tablette de contrebande
   - Voir son niveau, son XP, ses statistiques
   - Consulter les recettes disponibles

### Commandes Admin

```lua
-- Donner la tablette
/giveitem [id] alcohol_tablet 1

-- Donner des bouteilles vides
/giveitem [id] empty_bottle 10

-- Donner des ingrédients
/giveitem [id] levure 10
/giveitem [id] eau_source 10
/giveitem [id] sucre 10
```

## 🔧 Optimisations

- Système de cache pour les stats des joueurs
- Sauvegarde automatique toutes les 5 minutes
- Sauvegarde à la déconnexion
- Utilisation de ox_lib pour les progress bars
- NUI optimisé avec fermeture automatique
- Threads optimisés avec sleep dynamique
- Utilisation de ox_target pour réduire la charge (optionnel)

## 📍 Emplacements par Défaut

### Points de Farming (Levure)
- Paleto Bay : `vector3(1905.14, 4925.43, 48.86)`
- Mount Chiliad : `vector3(2229.23, 5577.13, 53.85)`
- Sandy Shores : `vector3(1392.64, 3606.62, 38.94)`
- Grapeseed : `vector3(2433.93, 4969.18, 46.81)`

### Laboratoires
- Labo #1 - Paleto Bay : `vector3(-131.18, 6366.42, 31.48)`
- Labo #2 - Sandy Shores : `vector3(1905.69, 4931.72, 48.86)`

### Receleurs
- Docks : `vector3(932.31, -2355.74, 30.58)`
- Sandy Shores : `vector3(1961.95, 3740.48, 32.34)`
- Paleto Bay : `vector3(-770.14, 5594.21, 33.49)`

## 🎨 Personnalisation de l'UI

L'UI peut être entièrement personnalisée dans `html/css/style.css`.

Couleurs principales utilisées :
- Primaire : `#667eea` (Bleu)
- Secondaire : `#764ba2` (Violet)
- Succès : `#2ecc71` (Vert)
- Erreur : `#ff6b6b` (Rouge)
- Attention : `#f7b731` (Jaune)

## 🐛 Debug

Activer le mode debug dans la config :
```lua
Config.Debug = true
```

Cela affichera des messages dans la console F8.

## 📝 Support

Pour tout problème ou suggestion :
1. Vérifier que toutes les dépendances sont installées
2. Vérifier que les items sont bien ajoutés à ox_inventory
3. Vérifier les logs F8 et console serveur
4. S'assurer que la base de données est accessible

## 📜 Licence

Ce script est fourni tel quel. Vous êtes libre de le modifier pour votre serveur.

## 🙏 Crédits

- Développé par **ZaK2BaK5906**
- UI inspirée par les designs modernes
- Icons : Font Awesome

---

**Bon farming et bonnes ventes ! 🍺💰**
