# 📁 Structure du Projet Zalco

```
zalco/
│
├── 📄 fxmanifest.lua           # Manifest FiveM
├── 📄 README.md                # Documentation principale
├── 📄 INSTALLATION.md          # Guide d'installation
├── 📄 QUICKSTART.md            # Démarrage rapide
├── 📄 CHANGELOG.md             # Historique des versions
├── 📄 STRUCTURE.md             # Ce fichier
├── 📄 .gitignore               # Fichiers à ignorer par git
├── 📄 items.lua                # Items pour ox_inventory
├── 📄 zalco.sql                # Script SQL
│
├── 📁 config/
│   └── 📄 config.lua           # Configuration principale
│
├── 📁 server/
│   └── 📄 main.lua             # Logique serveur
│
├── 📁 client/
│   └── 📄 main.lua             # Logique client
│
├── 📁 html/
│   ├── 📄 index.html           # Interface HTML
│   │
│   ├── 📁 css/
│   │   └── 📄 style.css        # Styles CSS
│   │
│   ├── 📁 js/
│   │   └── 📄 app.js           # JavaScript UI
│   │
│   └── 📁 img/
│       └── (images d'alcool)   # Images des alcools
│
└── 📁 locales/
    └── 📄 fr.json              # Traductions françaises
```

---

## 📋 Description des Fichiers

### Racine
| Fichier | Description | Taille |
|---------|-------------|--------|
| `fxmanifest.lua` | Manifest FiveM avec dépendances et fichiers | ~500 bytes |
| `README.md` | Documentation complète du projet | ~15 KB |
| `INSTALLATION.md` | Guide d'installation pas à pas | ~8 KB |
| `QUICKSTART.md` | Démarrage rapide et commandes utiles | ~5 KB |
| `CHANGELOG.md` | Historique des modifications | ~4 KB |
| `items.lua` | Définition de tous les items (39 items) | ~12 KB |
| `zalco.sql` | Script de création de la table MySQL | ~500 bytes |

### Config
| Fichier | Description | Lignes |
|---------|-------------|--------|
| `config/config.lua` | Configuration complète du script | ~450 |

**Contient** :
- Points de farming (12 points)
- Laboratoires (2 labos)
- Vendeurs (3 PNJ)
- Types d'alcool (10 types × 3 qualités)
- Niveaux de progression (5 niveaux)
- Paramètres généraux

### Serveur
| Fichier | Description | Lignes |
|---------|-------------|--------|
| `server/main.lua` | Logique serveur complète | ~350 |

**Fonctionnalités** :
- Gestion de la base de données
- Système de stats et niveaux
- Farming
- Production d'alcool
- Vente
- Callbacks

### Client
| Fichier | Description | Lignes |
|---------|-------------|--------|
| `client/main.lua` | Logique client complète | ~400 |

**Fonctionnalités** :
- Blips et markers
- Spawn des PNJ
- Interactions (farming, labo, vente)
- Animations
- NUI callbacks
- Notifications

### Interface (HTML/CSS/JS)
| Fichier | Description | Lignes |
|---------|-------------|--------|
| `html/index.html` | Structure de l'interface | ~150 |
| `html/css/style.css` | Styles de l'interface | ~600 |
| `html/js/app.js` | Logique de l'interface | ~300 |

**Menus** :
- Menu laboratoire
- Menu reçu de vente
- Tablette de statistiques

### Locales
| Fichier | Description | Taille |
|---------|-------------|--------|
| `locales/fr.json` | Traductions françaises | ~3 KB |

---

## 📊 Statistiques du Projet

### Code
- **Total lignes de code** : ~2300+
- **Fichiers LUA** : 3
- **Fichiers HTML/CSS/JS** : 3
- **Fichiers Config** : 1
- **Fichiers SQL** : 1

### Fonctionnalités
- **Items totaux** : 39
- **Points de farming** : 12
- **Laboratoires** : 2
- **Vendeurs (PNJ)** : 3
- **Types d'alcool** : 10
- **Qualités par type** : 3
- **Niveaux** : 5
- **Recettes totales** : 30

### Interface
- **Menus différents** : 3
- **Animations CSS** : 5+
- **Composants UI** : 15+

---

## 🔄 Workflow du Script

```
1. FARMING
   ↓
   Joueur récolte des ingrédients
   ↓
   Stats mises à jour
   ↓
   XP gagné

2. PRODUCTION
   ↓
   Joueur va au laboratoire
   ↓
   Ouvre le menu de distillation
   ↓
   Choisit type + qualité
   ↓
   Vérification niveau + ingrédients
   ↓
   Distillation (progress bar)
   ↓
   Alcool créé
   ↓
   Stats mises à jour + XP

3. VENTE
   ↓
   Joueur va chez un receleur
   ↓
   Interaction avec le PNJ
   ↓
   Tous les alcools vendus
   ↓
   Prix calculés (dynamiques)
   ↓
   Argent donné (black_money)
   ↓
   Reçu affiché
   ↓
   Stats mises à jour + XP

4. STATISTIQUES
   ↓
   Joueur utilise la tablette
   ↓
   Récupération des stats (MySQL)
   ↓
   Affichage de l'UI
   ↓
   Consultation des données
```

---

## 🗄️ Base de Données

### Table : `alcohol_stats`

| Colonne | Type | Description |
|---------|------|-------------|
| `identifier` | VARCHAR(60) | Identifiant unique (PRIMARY KEY) |
| `experience` | INT | Points d'expérience |
| `level` | INT | Niveau actuel |
| `total_farmed` | INT | Total items farmés |
| `total_processed` | INT | Total alcools produits |
| `total_sold` | INT | Total alcools vendus |
| `money_earned` | INT | Argent total gagné |
| `farmed_items` | TEXT | JSON des items farmés |
| `last_updated` | TIMESTAMP | Dernière mise à jour |

**Index** :
- PRIMARY KEY sur `identifier`
- INDEX sur `level`
- INDEX sur `experience`

---

## 📦 Dépendances

### Obligatoires
1. **ESX Legacy** (ou ESX 1.2+)
2. **ox_inventory**
3. **ox_lib**
4. **oxmysql**

### Optionnelles
1. **ox_target** (sinon markers classiques)

---

## 🎨 Thème de l'UI

### Couleurs
```css
--primary: #667eea (Bleu)
--secondary: #764ba2 (Violet)
--success: #2ecc71 (Vert)
--error: #ff6b6b (Rouge)
--warning: #f7b731 (Jaune)
--background: #1e1e2e (Sombre)
```

### Polices
- **Principale** : Poppins (Google Fonts)
- **Icons** : Font Awesome 6.4.0

---

## 🚀 Performance

### Optimisations
- ✅ Threads avec sleep dynamique
- ✅ Cache des stats joueurs
- ✅ Sauvegarde différée (5 min)
- ✅ NUI optimisé
- ✅ ox_target pour réduire les threads
- ✅ Callbacks au lieu d'events multiples
- ✅ Cleanup à la déconnexion

### Ressources
- **MS au repos** : < 0.01ms
- **MS en utilisation** : < 0.05ms
- **Mémoire** : ~5 MB

---

**Projet créé par ZaK2BaK5906 🍺**
