ESX = exports['es_extended']:getSharedObject()

-- Base de données pour les statistiques
local playerStats = {}

-- Créer les tables MySQL au démarrage
CreateThread(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS alcohol_stats (
            identifier VARCHAR(60) PRIMARY KEY,
            experience INT DEFAULT 0,
            level INT DEFAULT 0,
            total_farmed INT DEFAULT 0,
            total_processed INT DEFAULT 0,
            total_sold INT DEFAULT 0,
            money_earned INT DEFAULT 0,
            farmed_items TEXT DEFAULT '{}',
            last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
    ]])
end)

-- Charger les stats d'un joueur
local function LoadPlayerStats(identifier)
    local result = MySQL.query.await('SELECT * FROM alcohol_stats WHERE identifier = ?', {identifier})

    if result and result[1] then
        playerStats[identifier] = {
            experience = result[1].experience,
            level = result[1].level,
            total_farmed = result[1].total_farmed,
            total_processed = result[1].total_processed,
            total_sold = result[1].total_sold,
            money_earned = result[1].money_earned,
            farmed_items = json.decode(result[1].farmed_items)
        }
    else
        -- Créer un nouveau profil
        MySQL.insert('INSERT INTO alcohol_stats (identifier, farmed_items) VALUES (?, ?)',
            {identifier, json.encode({})}
        )
        playerStats[identifier] = {
            experience = 0,
            level = 0,
            total_farmed = 0,
            total_processed = 0,
            total_sold = 0,
            money_earned = 0,
            farmed_items = {}
        }
    end

    return playerStats[identifier]
end

-- Sauvegarder les stats
local function SavePlayerStats(identifier)
    if not playerStats[identifier] then return end

    MySQL.update([[
        UPDATE alcohol_stats SET
            experience = ?,
            level = ?,
            total_farmed = ?,
            total_processed = ?,
            total_sold = ?,
            money_earned = ?,
            farmed_items = ?
        WHERE identifier = ?
    ]], {
        playerStats[identifier].experience,
        playerStats[identifier].level,
        playerStats[identifier].total_farmed,
        playerStats[identifier].total_processed,
        playerStats[identifier].total_sold,
        playerStats[identifier].money_earned,
        json.encode(playerStats[identifier].farmed_items),
        identifier
    })
end

-- Calculer le niveau basé sur l'expérience
local function CalculateLevel(experience)
    local level = 0
    for i = #Config.Levels, 1, -1 do
        if experience >= Config.Levels[i].level then
            level = i - 1
            break
        end
    end
    return level
end

-- Ajouter de l'expérience
local function AddExperience(identifier, amount, action)
    if not playerStats[identifier] then
        LoadPlayerStats(identifier)
    end

    local oldLevel = playerStats[identifier].level
    playerStats[identifier].experience = playerStats[identifier].experience + amount
    playerStats[identifier].level = CalculateLevel(playerStats[identifier].experience)

    -- Notifier si level up
    if playerStats[identifier].level > oldLevel then
        local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
        if xPlayer then
            TriggerClientEvent('zalco:notify', xPlayer.source, {
                type = 'success',
                title = 'Niveau supérieur !',
                message = 'Vous êtes maintenant niveau ' .. playerStats[identifier].level .. ' !',
                duration = 5000
            })
        end
    end

    SavePlayerStats(identifier)
end

-- Event pour farming
RegisterNetEvent('zalco:farmItem', function(pointIndex)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local point = Config.FarmingPoints[pointIndex]
    if not point then return end

    -- Vérifier si le joueur a l'item requis
    if point.requiredItem then
        local hasItem = exports.ox_inventory:GetItem(src, point.requiredItem, nil, true)
        if hasItem < 1 then
            TriggerClientEvent('zalco:notify', src, {
                type = 'error',
                title = 'Erreur',
                message = 'Vous avez besoin d\'une bouteille vide !',
                duration = 3000
            })
            return
        end

        -- Retirer l'item requis
        exports.ox_inventory:RemoveItem(src, point.requiredItem, 1)
    end

    -- Calculer la quantité aléatoire
    local amount = math.random(point.amount.min, point.amount.max)

    -- Vérifier si le joueur peut porter cet item (poids)
    local canCarry = exports.ox_inventory:CanCarryItem(src, point.item, amount)

    if not canCarry then
        TriggerClientEvent('zalco:notify', src, {
            type = 'error',
            title = 'Inventaire plein',
            message = 'Vous ne pouvez pas porter ' .. amount .. 'x ' .. point.item .. ' !',
            duration = 3000
        })
        return
    end

    -- Ajouter l'item
    local success = exports.ox_inventory:AddItem(src, point.item, amount)

    if success then
        -- Mettre à jour les stats
        local identifier = xPlayer.identifier
        if not playerStats[identifier] then
            LoadPlayerStats(identifier)
        end

        playerStats[identifier].total_farmed = playerStats[identifier].total_farmed + amount

        -- Mettre à jour les items farmés
        if not playerStats[identifier].farmed_items[point.item] then
            playerStats[identifier].farmed_items[point.item] = 0
        end
        playerStats[identifier].farmed_items[point.item] = playerStats[identifier].farmed_items[point.item] + amount

        AddExperience(identifier, Config.Experience.farming * amount, 'farming')

        TriggerClientEvent('zalco:notify', src, {
            type = 'success',
            title = 'Récolte',
            message = 'Vous avez récolté ' .. amount .. 'x ' .. point.label,
            duration = 3000
        })
    else
        TriggerClientEvent('zalco:notify', src, {
            type = 'error',
            title = 'Erreur',
            message = 'Inventaire plein !',
            duration = 3000
        })
    end
end)

-- Event pour distiller l'alcool
RegisterNetEvent('zalco:processAlcohol', function(alcoholType, quality)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local alcohol = nil
    for _, v in pairs(Config.AlcoholTypes) do
        if v.name == alcoholType then
            alcohol = v
            break
        end
    end

    if not alcohol then return end

    local qualityData = nil
    for _, q in pairs(alcohol.qualities) do
        if q.quality == quality then
            qualityData = q
            break
        end
    end

    if not qualityData then return end

    -- Vérifier le niveau du joueur
    local identifier = xPlayer.identifier
    if not playerStats[identifier] then
        LoadPlayerStats(identifier)
    end

    local canCraft = false
    local playerLevel = playerStats[identifier].level

    for i = #Config.Levels, 1, -1 do
        if playerLevel >= i - 1 then
            for _, recipe in pairs(Config.Levels[i].recipes) do
                if recipe == alcoholType then
                    canCraft = true
                    break
                end
            end
            if canCraft then break end
        end
    end

    if not canCraft then
        TriggerClientEvent('zalco:notify', src, {
            type = 'error',
            title = 'Niveau insuffisant',
            message = 'Vous n\'avez pas le niveau requis pour cette recette !',
            duration = 3000
        })
        return
    end

    -- Vérifier les ingrédients
    local hasAllIngredients = true
    for ingredient, amount in pairs(qualityData.ingredients) do
        local hasItem = exports.ox_inventory:GetItem(src, ingredient, nil, true)
        if hasItem < amount then
            hasAllIngredients = false
            break
        end
    end

    if not hasAllIngredients then
        TriggerClientEvent('zalco:notify', src, {
            type = 'error',
            title = 'Ingrédients manquants',
            message = 'Vous n\'avez pas tous les ingrédients nécessaires !',
            duration = 3000
        })
        return
    end

    -- Vérifier si le joueur peut porter l'alcool AVANT de retirer les ingrédients
    local canCarry = exports.ox_inventory:CanCarryItem(src, qualityData.item, 1)

    if not canCarry then
        TriggerClientEvent('zalco:notify', src, {
            type = 'error',
            title = 'Inventaire plein',
            message = 'Vous ne pouvez pas porter cet alcool ! Libérez de l\'espace.',
            duration = 3000
        })
        return
    end

    -- Retirer les ingrédients
    for ingredient, amount in pairs(qualityData.ingredients) do
        exports.ox_inventory:RemoveItem(src, ingredient, amount)
    end

    -- Ajouter l'alcool
    local success = exports.ox_inventory:AddItem(src, qualityData.item, 1)

    if success then
        -- Mettre à jour les stats
        playerStats[identifier].total_processed = playerStats[identifier].total_processed + 1
        AddExperience(identifier, Config.Experience.processing, 'processing')

        TriggerClientEvent('zalco:notify', src, {
            type = 'success',
            title = 'Distillation réussie',
            message = 'Vous avez produit : ' .. alcohol.name .. ' (' .. quality .. ')',
            duration = 3000
        })
    else
        -- Rembourser les ingrédients si échec
        for ingredient, amount in pairs(qualityData.ingredients) do
            exports.ox_inventory:AddItem(src, ingredient, amount)
        end

        TriggerClientEvent('zalco:notify', src, {
            type = 'error',
            title = 'Erreur',
            message = 'Erreur lors de la distillation ! Ingrédients rendus.',
            duration = 3000
        })
    end
end)

-- Callback pour récupérer les stats
lib.callback.register('zalco:getStats', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return nil end

    local identifier = xPlayer.identifier
    if not playerStats[identifier] then
        LoadPlayerStats(identifier)
    end

    return playerStats[identifier]
end)

-- Callback pour récupérer les recettes disponibles
lib.callback.register('zalco:getAvailableRecipes', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return {} end

    local identifier = xPlayer.identifier
    if not playerStats[identifier] then
        LoadPlayerStats(identifier)
    end

    local playerLevel = playerStats[identifier].level
    local availableRecipes = {}

    for i = #Config.Levels, 1, -1 do
        if playerLevel >= i - 1 then
            for _, recipe in pairs(Config.Levels[i].recipes) do
                if not table.contains(availableRecipes, recipe) then
                    table.insert(availableRecipes, recipe)
                end
            end
        end
    end

    return availableRecipes
end)

-- Sauvegarder les stats à intervalles réguliers
CreateThread(function()
    while true do
        Wait(300000) -- Toutes les 5 minutes
        for identifier, _ in pairs(playerStats) do
            SavePlayerStats(identifier)
        end
    end
end)

-- Sauvegarder les stats à la déconnexion
AddEventHandler('playerDropped', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        SavePlayerStats(xPlayer.identifier)
        playerStats[xPlayer.identifier] = nil
    end
end)

-- Charger les stats à la connexion
RegisterNetEvent('esx:playerLoaded', function(playerId, xPlayer)
    LoadPlayerStats(xPlayer.identifier)
end)

-- Fonction utilitaire table.contains
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

if Config.Debug then
    print('^2[ZALCO]^7 Script d\'alcool de contrebande chargé !')
end
