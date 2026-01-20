-- =============================================================================
-- ZALCO INTERIM - SERVER SIDE
-- Systeme de jobs interimaires - Gestion stats, paiements, XP
-- =============================================================================

local ESX = exports['es_extended']:getSharedObject()

-- Cache des stats joueurs
local PlayerStats = {}

-- =============================================================================
-- DATABASE INITIALIZATION
-- =============================================================================

MySQL.ready(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `interim_stats` (
            `identifier` VARCHAR(60) NOT NULL,
            `job_stats` LONGTEXT DEFAULT '{}',
            `total_earnings` INT DEFAULT 0,
            `total_shifts` INT DEFAULT 0,
            `total_tasks` INT DEFAULT 0,
            `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])

    print('^2[ZALCO_INTERIM]^0 Database initialized')
end)

-- =============================================================================
-- PLAYER STATS MANAGEMENT
-- =============================================================================

function LoadPlayerStats(identifier)
    local result = MySQL.query.await('SELECT * FROM interim_stats WHERE identifier = ?', {identifier})

    if result and result[1] then
        local data = result[1]
        PlayerStats[identifier] = {
            job_stats = json.decode(data.job_stats) or {},
            total_earnings = data.total_earnings or 0,
            total_shifts = data.total_shifts or 0,
            total_tasks = data.total_tasks or 0,
        }
    else
        PlayerStats[identifier] = {
            job_stats = {},
            total_earnings = 0,
            total_shifts = 0,
            total_tasks = 0,
        }

        MySQL.insert('INSERT INTO interim_stats (identifier) VALUES (?)', {identifier})
    end

    return PlayerStats[identifier]
end

function SavePlayerStats(identifier)
    local stats = PlayerStats[identifier]
    if not stats then return end

    MySQL.update([[
        UPDATE interim_stats SET
            job_stats = ?,
            total_earnings = ?,
            total_shifts = ?,
            total_tasks = ?
        WHERE identifier = ?
    ]], {
        json.encode(stats.job_stats),
        stats.total_earnings,
        stats.total_shifts,
        stats.total_tasks,
        identifier
    })
end

function GetPlayerJobStats(identifier, jobId)
    local stats = PlayerStats[identifier]
    if not stats then return nil end

    if not stats.job_stats[jobId] then
        stats.job_stats[jobId] = {
            xp = 0,
            level = 0,
            shifts = 0,
            tasks = 0,
            earnings = 0,
        }
    end

    return stats.job_stats[jobId]
end

function GetPlayerLevel(identifier, jobId)
    local jobStats = GetPlayerJobStats(identifier, jobId)
    if not jobStats then return 0, 1.0 end

    local level = 0
    local bonus = 1.0

    for i, levelData in ipairs(Config.Levels) do
        if jobStats.xp >= levelData.xp then
            level = i - 1
            bonus = levelData.bonus
        else
            break
        end
    end

    return level, bonus
end

function AddXP(identifier, jobId, amount)
    local jobStats = GetPlayerJobStats(identifier, jobId)
    if not jobStats then return end

    local oldLevel, _ = GetPlayerLevel(identifier, jobId)
    jobStats.xp = jobStats.xp + amount

    local newLevel, _ = GetPlayerLevel(identifier, jobId)

    if newLevel > oldLevel then
        local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
        if xPlayer then
            TriggerClientEvent('zalco_interim:levelUp', xPlayer.source, jobId, newLevel, Config.Levels[newLevel + 1].name)
        end
    end

    SavePlayerStats(identifier)
end

-- =============================================================================
-- EVENTS
-- =============================================================================

-- Chargement joueur
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    LoadPlayerStats(xPlayer.identifier)
end)

-- Deconnexion joueur
AddEventHandler('playerDropped', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        SavePlayerStats(xPlayer.identifier)
        PlayerStats[xPlayer.identifier] = nil
    end
end)

-- Debut de shift
RegisterNetEvent('zalco_interim:startShift')
AddEventHandler('zalco_interim:startShift', function(jobId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local identifier = xPlayer.identifier
    local stats = PlayerStats[identifier]

    if stats then
        stats.total_shifts = stats.total_shifts + 1

        local jobStats = GetPlayerJobStats(identifier, jobId)
        if jobStats then
            jobStats.shifts = jobStats.shifts + 1
        end

        SavePlayerStats(identifier)
    end

    if Config.Debug then
        print(('[ZALCO_INTERIM] %s started shift: %s'):format(xPlayer.getName(), jobId))
    end
end)

-- Fin de shift
RegisterNetEvent('zalco_interim:endShift')
AddEventHandler('zalco_interim:endShift', function(jobId, earnings, tasksCompleted)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local identifier = xPlayer.identifier
    local stats = PlayerStats[identifier]

    if stats then
        stats.total_earnings = stats.total_earnings + earnings
        stats.total_tasks = stats.total_tasks + tasksCompleted

        local jobStats = GetPlayerJobStats(identifier, jobId)
        if jobStats then
            jobStats.earnings = jobStats.earnings + earnings
            jobStats.tasks = jobStats.tasks + tasksCompleted
        end

        SavePlayerStats(identifier)
    end

    if Config.Debug then
        print(('[ZALCO_INTERIM] %s ended shift: %s | Earnings: $%d | Tasks: %d'):format(
            xPlayer.getName(), jobId, earnings, tasksCompleted
        ))
    end
end)

-- Farm item
RegisterNetEvent('zalco_interim:farmItem')
AddEventHandler('zalco_interim:farmItem', function(jobId, itemName, minAmount, maxAmount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local amount = math.random(minAmount, maxAmount)
    local jobData = Config.Jobs[jobId]

    if not jobData then return end

    -- Bonus de niveau
    local identifier = xPlayer.identifier
    local level, bonus = GetPlayerLevel(identifier, jobId)

    -- Chance de bonus item avec le niveau
    if math.random() < (bonus - 1.0) then
        amount = amount + 1
    end

    -- Donner item
    local canCarry = exports.ox_inventory:CanCarryItem(source, itemName, amount)

    if canCarry then
        exports.ox_inventory:AddItem(source, itemName, amount)

        -- Ajouter XP
        AddXP(identifier, jobId, jobData.xpPerAction or 2)

        TriggerClientEvent('zalco_interim:notify', source, '+' .. amount .. 'x ' .. itemName, 'success')
    else
        TriggerClientEvent('zalco_interim:notify', source, 'Inventaire plein!', 'error')
    end
end)

-- Livraison complete
RegisterNetEvent('zalco_interim:deliveryComplete')
AddEventHandler('zalco_interim:deliveryComplete', function(jobId, reward)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local identifier = xPlayer.identifier
    local level, bonus = GetPlayerLevel(identifier, jobId)

    -- Bonus de niveau sur le paiement
    local finalReward = math.floor(reward * bonus)

    xPlayer.addMoney(finalReward, 'Livraison interim')

    -- Ajouter XP
    local jobData = Config.Jobs[jobId]
    AddXP(identifier, jobId, jobData and jobData.xpPerAction or 3)

    if Config.Debug then
        print(('[ZALCO_INTERIM] %s completed delivery | Reward: $%d (bonus: x%.2f)'):format(
            xPlayer.getName(), finalReward, bonus
        ))
    end
end)

-- Ajouter argent (agent entretien, jardinier, eboueur)
RegisterNetEvent('zalco_interim:addMoney')
AddEventHandler('zalco_interim:addMoney', function(amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    xPlayer.addMoney(amount, 'Travail interim')
end)

-- Acheter equipement chez NPC
RegisterNetEvent('zalco_interim:buyItem')
AddEventHandler('zalco_interim:buyItem', function(jobId, itemName, price)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    -- Verifier que le job existe et a un shop
    local jobData = Config.Jobs[jobId]
    if not jobData or not jobData.npcShop or not jobData.npcShop.items then
        TriggerClientEvent('zalco_interim:notify', source, 'Erreur configuration shop', 'error')
        return
    end

    -- Verifier que l'item est dans le shop (securite anti-cheat)
    local validItem = false
    local actualPrice = 0
    for _, shopItem in ipairs(jobData.npcShop.items) do
        if shopItem.item == itemName then
            validItem = true
            actualPrice = shopItem.price
            break
        end
    end

    if not validItem then
        TriggerClientEvent('zalco_interim:notify', source, 'Item invalide', 'error')
        return
    end

    -- Utiliser le prix du serveur (securite)
    price = actualPrice

    -- Verifier argent
    if xPlayer.getMoney() < price then
        TriggerClientEvent('zalco_interim:notify', source, 'Pas assez d\'argent! ($' .. price .. ')', 'error')
        return
    end

    -- Verifier si peut porter
    local canCarry = exports.ox_inventory:CanCarryItem(source, itemName, 1)
    if not canCarry then
        TriggerClientEvent('zalco_interim:notify', source, 'Inventaire plein!', 'error')
        return
    end

    -- Transaction
    xPlayer.removeMoney(price, 'Achat equipement interim: ' .. itemName)
    exports.ox_inventory:AddItem(source, itemName, 1)

    TriggerClientEvent('zalco_interim:notify', source, 'Achat: ' .. itemName .. ' (-$' .. price .. ')', 'success')

    if Config.Debug then
        print(('[ZALCO_INTERIM] %s bought %s for $%d'):format(xPlayer.getName(), itemName, price))
    end
end)

-- =============================================================================
-- CALLBACKS
-- =============================================================================

-- Vendre items (mineur, bucheron, boucher)
lib.callback.register('zalco_interim:sellItems', function(source, jobId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return {success = false, message = 'Erreur joueur'} end

    local jobData = Config.Jobs[jobId]
    if not jobData or not jobData.npcSell or not jobData.npcSell.prices then
        return {success = false, message = 'Pas de point de vente pour ce job'}
    end

    local identifier = xPlayer.identifier
    local level, bonus = GetPlayerLevel(identifier, jobId)

    local total = 0
    local soldItems = {}

    for itemName, price in pairs(jobData.npcSell.prices) do
        local itemCount = exports.ox_inventory:GetItemCount(source, itemName)

        if itemCount and itemCount > 0 then
            exports.ox_inventory:RemoveItem(source, itemName, itemCount)

            local itemTotal = math.floor(itemCount * price * bonus)
            total = total + itemTotal

            table.insert(soldItems, {
                name = itemName,
                count = itemCount,
                price = itemTotal
            })
        end
    end

    if total > 0 then
        xPlayer.addMoney(total, 'Vente interim ' .. jobId)

        -- Ajouter XP pour la vente
        AddXP(identifier, jobId, math.floor(total / 50))

        return {
            success = true,
            total = total,
            items = soldItems,
            bonus = bonus
        }
    else
        return {success = false, message = 'Rien a vendre!'}
    end
end)

-- Obtenir stats joueur
lib.callback.register('zalco_interim:getStats', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return nil end

    local identifier = xPlayer.identifier
    local stats = PlayerStats[identifier]

    if not stats then
        stats = LoadPlayerStats(identifier)
    end

    -- Calculer niveaux pour chaque job
    local jobLevels = {}
    for jobId, jobStats in pairs(stats.job_stats) do
        local level, bonus = GetPlayerLevel(identifier, jobId)
        jobLevels[jobId] = {
            level = level,
            levelName = Config.Levels[level + 1] and Config.Levels[level + 1].name or 'Debutant',
            xp = jobStats.xp,
            nextLevelXp = Config.Levels[level + 2] and Config.Levels[level + 2].xp or jobStats.xp,
            bonus = bonus,
            shifts = jobStats.shifts,
            tasks = jobStats.tasks,
            earnings = jobStats.earnings,
        }
    end

    return {
        total_earnings = stats.total_earnings,
        total_shifts = stats.total_shifts,
        total_tasks = stats.total_tasks,
        jobs = jobLevels,
        levels = Config.Levels,
    }
end)

-- =============================================================================
-- COMMANDS
-- =============================================================================

-- Commande admin pour reset stats
RegisterCommand('resetinterimstats', function(source, args)
    if source ~= 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer or not xPlayer.getGroup() == 'admin' then
            return
        end
    end

    local targetId = tonumber(args[1])
    if not targetId then
        print('[ZALCO_INTERIM] Usage: /resetinterimstats [player_id]')
        return
    end

    local targetPlayer = ESX.GetPlayerFromId(targetId)
    if targetPlayer then
        local identifier = targetPlayer.identifier
        PlayerStats[identifier] = {
            job_stats = {},
            total_earnings = 0,
            total_shifts = 0,
            total_tasks = 0,
        }
        SavePlayerStats(identifier)
        print('[ZALCO_INTERIM] Stats reset for player ' .. targetId)
    end
end, true)

-- =============================================================================
-- AUTO SAVE
-- =============================================================================

CreateThread(function()
    while true do
        Wait(300000) -- 5 minutes

        for identifier, stats in pairs(PlayerStats) do
            SavePlayerStats(identifier)
        end

        if Config.Debug then
            print('[ZALCO_INTERIM] Auto-saved all player stats')
        end
    end
end)

-- =============================================================================
-- EXPORTS
-- =============================================================================

exports('GetPlayerStats', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return nil end
    return PlayerStats[xPlayer.identifier]
end)

exports('GetPlayerJobLevel', function(source, jobId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return 0, 1.0 end
    return GetPlayerLevel(xPlayer.identifier, jobId)
end)

-- =============================================================================
-- MISSIONS ILLEGALES
-- =============================================================================

-- Debut mission illegale
RegisterNetEvent('zalco_interim:startIllegalMission')
AddEventHandler('zalco_interim:startIllegalMission', function(jobId, missionId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if Config.Debug then
        print(('[ZALCO_INTERIM] %s started illegal mission: %s (%s)'):format(
            xPlayer.getName(), missionId, jobId
        ))
    end
end)

-- Mission illegale complete
RegisterNetEvent('zalco_interim:completeIllegalMission')
AddEventHandler('zalco_interim:completeIllegalMission', function(jobId, missionId, reward, xpBonus, policeAlert)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local identifier = xPlayer.identifier

    -- Payer en argent sale (black_money)
    xPlayer.addAccountMoney('black_money', reward, 'Mission illegale interim')

    -- Ajouter XP bonus
    if xpBonus and xpBonus > 0 then
        AddXP(identifier, jobId, xpBonus)
    end

    -- Mettre a jour stats
    local stats = PlayerStats[identifier]
    if stats then
        stats.total_earnings = stats.total_earnings + reward

        local jobStats = GetPlayerJobStats(identifier, jobId)
        if jobStats then
            jobStats.earnings = jobStats.earnings + reward

            -- Tracker missions illegales
            if not jobStats.illegal_missions then
                jobStats.illegal_missions = 0
            end
            jobStats.illegal_missions = jobStats.illegal_missions + 1
        end

        SavePlayerStats(identifier)
    end

    if Config.Debug then
        print(('[ZALCO_INTERIM] %s completed illegal mission: %s | Reward: $%d (black_money) | Police: %s'):format(
            xPlayer.getName(), missionId, reward, tostring(policeAlert)
        ))
    end

    -- Alerte police si necessaire
    if policeAlert then
        -- Notifier les flics en ligne
        local xPlayers = ESX.GetExtendedPlayers('job', 'police')
        for _, cop in pairs(xPlayers) do
            TriggerClientEvent('zalco_interim:policeAlert', cop.source, GetEntityCoords(GetPlayerPed(source)), 'Activite suspecte signalee')
        end

        if Config.Debug then
            print('[ZALCO_INTERIM] Police alerted! ' .. #xPlayers .. ' cops notified')
        end
    end
end)

-- Mission illegale echouee
RegisterNetEvent('zalco_interim:failIllegalMission')
AddEventHandler('zalco_interim:failIllegalMission', function(jobId, missionId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if Config.Debug then
        print(('[ZALCO_INTERIM] %s failed illegal mission: %s (%s)'):format(
            xPlayer.getName(), missionId or 'unknown', jobId
        ))
    end
end)

-- =============================================================================
-- POLICE ALERT EVENT (Client)
-- =============================================================================

RegisterNetEvent('zalco_interim:policeAlert')
AddEventHandler('zalco_interim:policeAlert', function(coords, message)
    -- Ce event est trigger cote client pour les flics
end)
