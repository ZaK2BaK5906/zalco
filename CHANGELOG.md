# 📝 Changelog - Zalco

Toutes les modifications notables de ce projet seront documentées dans ce fichier.

---

## [1.0.0] - 2026-01-08

### 🎉 Version Initiale

#### ✨ Ajouté
- **Système de farming complet**
  - 4 points de récolte pour la levure
  - 2 points pour l'eau de source
  - 2 points pour le sucre
  - Points pour raisin, pomme, maïs, orge
  - Animations de récolte
  - Quantités aléatoires configurables

- **10 types d'alcool différents**
  - Vodka, Whisky, Rhum, Gin, Tequila
  - Calvados, Moonshine, Absinthe, Cognac, Pastis
  - 3 qualités par type (mauvaise, moyenne, bonne)
  - Total de 30 alcools différents

- **2 laboratoires clandestins**
  - Système de distillation
  - Menu UI personnalisé
  - Vérification des ingrédients
  - Animations de production
  - Temps de distillation variable

- **3 points de vente (PNJ)**
  - Receleurs avec PNJ spawné
  - Prix dynamiques (-20% à +30%)
  - Système de reçu détaillé
  - Paiement en argent sale

- **Système de progression**
  - 5 niveaux de progression
  - Système d'expérience
  - Recettes débloquables
  - Tablette de statistiques

- **Tablette de contrebande**
  - Statistiques détaillées
  - Historique des items farmés
  - Progression et niveaux
  - Argent total gagné
  - Recettes disponibles

- **Interface utilisateur moderne**
  - Design sombre avec thème violet/bleu
  - Animations fluides
  - Responsive
  - Icons Font Awesome
  - Menus de laboratoire, vente et tablette

- **Base de données MySQL**
  - Sauvegarde des statistiques
  - Auto-création de table
  - Sauvegarde automatique (5 min)
  - Sauvegarde à la déconnexion

- **Optimisations**
  - Système de cache pour les stats
  - Threads optimisés avec sleep dynamique
  - Utilisation de ox_lib pour les progress bars
  - Support de ox_target (optionnel)
  - NUI optimisé

- **Configuration complète**
  - Points de farming configurables
  - Laboratoires configurables
  - Receleurs configurables
  - Prix et ingrédients configurables
  - Temps de farming/distillation configurables
  - Expérience et niveaux configurables

#### 📋 Documentation
- README.md complet avec toutes les informations
- INSTALLATION.md avec guide d'installation rapide
- items.lua avec tous les items pour ox_inventory
- zalco.sql pour la création de table
- Locales FR (fr.json)

#### 🔧 Technique
- Support ESX Legacy
- Compatible ox_inventory
- Utilisation de ox_lib
- Utilisation de oxmysql
- Support optionnel de ox_target
- Code optimisé et commenté

---

## 🔮 À venir (Roadmap)

### Version 1.1.0 (Prévue)
- [ ] Système de jobs/gangs (territoires)
- [ ] Système de coffre pour les labos
- [ ] Raids de police
- [ ] Système de qualité aléatoire
- [ ] Missions de livraison

### Version 1.2.0 (Prévue)
- [ ] Support multilingue (EN, ES, DE)
- [ ] Système de réputation
- [ ] Événements aléatoires
- [ ] Améliorations de labo
- [ ] Système de contrats

### Idées futures
- [ ] Système de plantations personnelles
- [ ] Véhicules de transport spéciaux
- [ ] Système de dégustation (effets)
- [ ] Mini-jeux pour améliorer la qualité
- [ ] Classement des meilleurs producteurs

---

## 📊 Statistiques de la version 1.0.0

- **Lignes de code** : ~2500+
- **Fichiers** : 15+
- **Items totaux** : 39
- **Points d'intérêt** : 23
- **Types d'alcool** : 10
- **Qualités** : 3 par type
- **Niveaux de progression** : 5

---

## 🐛 Corrections de bugs

Aucun bug connu pour le moment.

Pour signaler un bug, merci de fournir :
1. Version du script
2. Version d'ESX
3. Version d'ox_inventory
4. Logs F8 et console serveur
5. Étapes pour reproduire le bug

---

**Merci d'utiliser Zalco ! 🍺**
