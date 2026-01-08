ESX = exports['es_extended']:getSharedObject()
local currentLab = nil
local isBusy = false

-- Système de vente aux PNJ dans la rue
local pedsSold = {} -- PNJ déjà vendus (cooldown)
local lastSaleTime = 0
local isSelling = false

-- Créer les blips
CreateThread(function()
    -- Blips des labos (si activés)
    for i, lab in pairs(Config.Labs) do
        if lab.blip.enabled then
            local blip = AddBlipForCoord(lab.coords.x, lab.coords.y, lab.coords.z)
            SetBlipSprite(blip, lab.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, lab.blip.scale)
            SetBlipColour(blip, lab.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(lab.name)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- Fonction pour vérifier si on est dans une zone interdite
local function IsInForbiddenZone()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for _, zone in pairs(Config.SellToPeds.forbiddenZones) do
        if #(playerCoords - zone.coords) < zone.radius then
            return true, zone.name
        end
    end
    return false, nil
end

-- Fonction pour obtenir la catégorie d'un PNJ
local function GetPedCategory(pedModel)
    for category, models in pairs(Config.SellToPeds.pedCategories) do
        for _, model in pairs(models) do
            if GetHashKey(model) == pedModel then
                return category
            end
        end
    end
    return 'default'
end

-- Fonction pour vérifier si un PNJ est blacklisté
local function IsPedBlacklisted(pedModel)
    for _, model in pairs(Config.SellToPeds.blacklistedPeds) do
        if GetHashKey(model) == pedModel then
            return true
        end
    end
    return false
end

-- Ajouter ox_target à tous les PNJ
CreateThread(function()
    if not Config.SellToPeds.enabled or not Config.UseTarget then return end

    exports.ox_target:addGlobalPed({
        {
            name = 'sell_alcohol',
            icon = 'fa-solid fa-bottle-droplet',
            label = 'Proposer de l\'alcool',
            canInteract = function(entity)
                -- Vérifier que c'est un PNJ et pas un joueur
                if IsPedAPlayer(entity) then return false end

                -- Vérifier que le PNJ est pas mort
                if IsEntityDead(entity) then return false end

                -- Vérifier que le PNJ est pas blacklisté
                local pedModel = GetEntityModel(entity)
                if IsPedBlacklisted(pedModel) then return false end

                -- Vérifier que le PNJ est pas dans un véhicule
                if IsPedInAnyVehicle(entity, false) then return false end

                -- Vérifier qu'on a pas déjà vendu à ce PNJ récemment
                local pedId = NetworkGetNetworkIdFromEntity(entity)
                if pedsSold[pedId] and (GetGameTimer() - pedsSold[pedId]) < Config.SellToPeds.pedCooldown then
                    return false
                end

                -- Vérifier le cooldown global
                if (GetGameTimer() - lastSaleTime) < Config.SellToPeds.cooldownBetweenSales then
                    return false
                end

                return true
            end,
            onSelect = function(data)
                local ped = data.entity
                SellToPed(ped)
            end,
            distance = Config.SellToPeds.targetDistance
        }
    })
end)

-- Nettoyer les PNJ vendus périodiquement
CreateThread(function()
    while true do
        Wait(60000) -- Toutes les minutes
        local currentTime = GetGameTimer()
        for pedId, time in pairs(pedsSold) do
            if (currentTime - time) > Config.SellToPeds.pedCooldown then
                pedsSold[pedId] = nil
            end
        end
    end
end)

-- Note: Le farming utilise TOUJOURS E (pas ox_target), géré dans le thread principal ci-dessous

-- Laboratoires
CreateThread(function()
    for i, lab in pairs(Config.Labs) do
        if Config.UseTarget then
            exports.ox_target:addSphereZone({
                coords = lab.coords,
                radius = 2.0,
                options = {
                    {
                        name = 'lab_' .. i,
                        icon = 'fa-solid fa-flask',
                        label = 'Ouvrir le laboratoire',
                        onSelect = function()
                            OpenLabMenu(i)
                        end,
                        distance = Config.InteractDistance
                    }
                }
            })
        end
    end
end)

-- Fonction pour afficher le texte stylé
local function ShowStyledText(text, key)
    SendNUIMessage({
        action = 'showHelpText',
        text = text,
        key = key or 'E'
    })
end

local function HideStyledText()
    SendNUIMessage({
        action = 'hideHelpText'
    })
end

-- Thread pour les markers de farming (TOUJOURS avec E, pas ox_target)
CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        -- Farming points
        for i, point in pairs(Config.FarmingPoints) do
            local distance = #(playerCoords - point.coords)
            if distance < Config.DrawDistance then
                sleep = 0
                DrawMarker(2, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 102, 126, 234, 200, true, true, 2, false, nil, nil, false)

                if distance < Config.InteractDistance then
                    ShowStyledText(point.label, 'E')
                    if IsControlJustReleased(0, 38) and not isBusy then
                        FarmItem(i, point)
                    end
                elseif distance < Config.DrawDistance then
                    HideStyledText()
                end
            end
        end

        -- Labs (utiliser ox_target SI activé, sinon markers)
        if not Config.UseTarget then
            for i, lab in pairs(Config.Labs) do
                local distance = #(playerCoords - lab.coords)
                if distance < Config.DrawDistance then
                    sleep = 0
                    DrawMarker(27, lab.coords.x, lab.coords.y, lab.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 1.0, 220, 20, 60, 200, false, true, 2, false, nil, nil, false)

                    if distance < Config.InteractDistance then
                        ShowStyledText('Ouvrir le laboratoire', 'E')
                        if IsControlJustReleased(0, 38) and not isBusy then
                            OpenLabMenu(i)
                        end
                    end
                end
            end
        end

        if sleep == 1000 then
            HideStyledText()
        end

        Wait(sleep)
    end
end)

-- Fonction de farming
function FarmItem(index, point)
    if isBusy then
        Notify({type = 'error', title = 'Action en cours', message = 'Vous êtes déjà en train de faire quelque chose !', duration = 3000})
        return
    end

    isBusy = true
    HideStyledText()
    local playerPed = PlayerPedId()

    -- S'assurer que le joueur est au sol
    local playerCoords = GetEntityCoords(playerPed)
    local groundZ = playerCoords.z
    local foundGround, groundZ = GetGroundZFor_3dCoord(playerCoords.x, playerCoords.y, playerCoords.z, groundZ, false)

    if foundGround then
        SetEntityCoords(playerPed, playerCoords.x, playerCoords.y, groundZ, false, false, false, false)
    end

    Wait(100)

    -- Animation
    if point.animation then
        RequestAnimDict(point.animation.dict)
        while not HasAnimDictLoaded(point.animation.dict) do
            Wait(100)
        end
        -- Utiliser TaskPlayAnim avec flag 1 pour rester au sol
        TaskPlayAnim(playerPed, point.animation.dict, point.animation.anim, 4.0, -4.0, -1, 1, 0, false, false, false)
    end

    -- Progress bar
    if lib.progressBar({
        duration = Config.FarmingTime,
        label = point.label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = point.animation.dict,
            clip = point.animation.anim
        }
    }) then
        ClearPedTasks(playerPed)
        TriggerServerEvent('zalco:farmItem', index)
    else
        ClearPedTasks(playerPed)
        Notify({type = 'error', title = 'Annulé', message = 'Action annulée !', duration = 3000})
    end

    isBusy = false
end

-- Ouvrir le menu du laboratoire
function OpenLabMenu(labIndex)
    if isBusy then
        Notify({type = 'error', title = 'Action en cours', message = 'Vous êtes déjà en train de faire quelque chose !', duration = 3000})
        return
    end

    currentLab = labIndex
    SendNUIMessage({
        action = 'openLab',
        alcoholTypes = Config.AlcoholTypes,
        levels = Config.Levels
    })
    SetNuiFocus(true, true)
end

-- Distiller l'alcool
RegisterNUICallback('processAlcohol', function(data, cb)
    if isBusy then
        cb({success = false, message = 'Action déjà en cours'})
        return
    end

    isBusy = true
    local playerPed = PlayerPedId()

    -- Trouver l'alcool
    local alcohol = nil
    for _, v in pairs(Config.AlcoholTypes) do
        if v.name == data.alcoholType then
            alcohol = v
            break
        end
    end

    if not alcohol then
        cb({success = false, message = 'Type d\'alcool invalide'})
        isBusy = false
        return
    end

    -- Fermer l'UI
    SetNuiFocus(false, false)
    SendNUIMessage({action = 'closeLab'})

    -- Animation
    RequestAnimDict('anim@amb@business@weed@weed_inspecting_high_dry@')
    while not HasAnimDictLoaded('anim@amb@business@weed@weed_inspecting_high_dry@') do
        Wait(100)
    end
    TaskPlayAnim(playerPed, 'anim@amb@business@weed@weed_inspecting_high_dry@', 'weed_inspecting_high_base_inspector', 8.0, -8.0, -1, 1, 0, false, false, false)

    -- Progress bar
    if lib.progressBar({
        duration = alcohol.distillationTime,
        label = 'Distillation en cours...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        }
    }) then
        ClearPedTasks(playerPed)
        TriggerServerEvent('zalco:processAlcohol', data.alcoholType, data.quality)
        cb({success = true})
    else
        ClearPedTasks(playerPed)
        Notify({type = 'error', title = 'Annulé', message = 'Distillation annulée !', duration = 3000})
        cb({success = false, message = 'Annulé'})
    end

    isBusy = false
end)

-- Vendre à un PNJ dans la rue
function SellToPed(ped)
    if isSelling then
        Notify({type = 'error', title = 'Vente en cours', message = 'Vous êtes déjà en train de vendre !', duration = 3000})
        return
    end

    -- Vérifier le cooldown global
    if (GetGameTimer() - lastSaleTime) < Config.SellToPeds.cooldownBetweenSales then
        local remaining = math.ceil((Config.SellToPeds.cooldownBetweenSales - (GetGameTimer() - lastSaleTime)) / 1000)
        Notify({type = 'error', title = 'Cooldown', message = 'Attendez ' .. remaining .. ' secondes avant la prochaine vente !', duration = 3000})
        return
    end

    -- Vérifier si on est dans une zone interdite
    local inForbiddenZone, zoneName = IsInForbiddenZone()
    if inForbiddenZone then
        Notify({type = 'error', title = 'Zone interdite', message = 'Vous ne pouvez pas vendre ici (' .. zoneName .. ') !', duration = 3000})

        -- Chance d'appeler la police si zone interdite
        if math.random(100) <= 50 then -- 50% de chance
            TriggerServerEvent('zalco:alertPolice', GetEntityCoords(PlayerPedId()))
            Notify({type = 'error', title = 'Police alertée !', message = 'Quelqu\'un a prévenu la police !', duration = 5000})
        end
        return
    end

    isSelling = true
    local playerPed = PlayerPedId()
    local pedModel = GetEntityModel(ped)
    local pedCategory = GetPedCategory(pedModel)
    local pedId = NetworkGetNetworkIdFromEntity(ped)

    -- Faire regarder le PNJ vers le joueur
    TaskTurnPedToFaceEntity(ped, playerPed, 2000)
    Wait(500)

    -- Envoyer au serveur pour vérifier qu'on a de l'alcool
    lib.callback('zalco:canSellToPed', false, function(canSell, alcoholList)
        if not canSell then
            Notify({type = 'error', title = 'Aucun alcool', message = 'Vous n\'avez aucun alcool à vendre !', duration = 3000})
            isSelling = false
            return
        end

        -- Chance de refus selon la catégorie du PNJ
        local refusalChance = Config.SellToPeds.refusalChance[pedCategory] or Config.SellToPeds.refusalChance.default
        if math.random(100) <= refusalChance then
            -- Refus
            TaskPlayAnim(ped, 'gestures@m@standing@casual', 'gesture_no_way', 8.0, -8.0, 1500, 0, 0, false, false, false)
            Notify({type = 'error', title = 'Refus', message = 'Le PNJ ne veut pas acheter...', duration = 3000})

            -- Petite chance d'appeler la police même en cas de refus
            local policeChance = Config.SellToPeds.policeCallChance[pedCategory] or Config.SellToPeds.policeCallChance.default
            if math.random(100) <= policeChance then
                TriggerServerEvent('zalco:alertPolice', GetEntityCoords(PlayerPedId()))
                Notify({type = 'error', title = 'Police alertée !', message = 'Le PNJ a appelé la police !', duration = 5000})
            end

            isSelling = false
            return
        end

        -- Acceptation de l'achat
        -- Animations
        RequestAnimDict(Config.SellToPeds.animations.player.dict)
        RequestAnimDict(Config.SellToPeds.animations.ped.dict)

        while not HasAnimDictLoaded(Config.SellToPeds.animations.player.dict) or
              not HasAnimDictLoaded(Config.SellToPeds.animations.ped.dict) do
            Wait(100)
        end

        TaskPlayAnim(playerPed, Config.SellToPeds.animations.player.dict, Config.SellToPeds.animations.player.anim, 8.0, -8.0, -1, Config.SellToPeds.animations.player.flag, 0, false, false, false)
        TaskPlayAnim(ped, Config.SellToPeds.animations.ped.dict, Config.SellToPeds.animations.ped.anim, 8.0, -8.0, -1, Config.SellToPeds.animations.ped.flag, 0, false, false, false)

        Wait(2000)
        ClearPedTasks(playerPed)
        ClearPedTasksImmediately(ped)

        -- Faire partir le PNJ
        TaskWanderStandard(ped, 10.0, 10)

        -- Envoyer la vente au serveur
        TriggerServerEvent('zalco:sellToPed', pedCategory, alcoholList)

        -- Mettre à jour les cooldowns
        pedsSold[pedId] = GetGameTimer()
        lastSaleTime = GetGameTimer()
        isSelling = false
    end)
end

-- Recevoir le reçu de vente
RegisterNetEvent('zalco:showSellReceipt', function(items, total)
    SendNUIMessage({
        action = 'showReceipt',
        items = items,
        total = total
    })
    SetNuiFocus(true, true)
end)

-- Fermer l'UI
RegisterNUICallback('closeUI', function(data, cb)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({action = 'closeAll'})
    cb('ok')
end)

-- Fermer avec ESC
RegisterNUICallback('escape', function(data, cb)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({action = 'closeAll'})
    cb('ok')
end)

-- Ouvrir la tablette
RegisterNetEvent('zalco:openTablet', function()
    lib.callback('zalco:getStats', false, function(stats)
        SendNUIMessage({
            action = 'openTablet',
            stats = stats,
            levels = Config.Levels
        })
        SetNuiFocus(true, true)
    end)
end)

-- Système de notifications
function Notify(data)
    if Config.Notification == 'ox_lib' then
        lib.notify({
            title = data.title,
            description = data.message,
            type = data.type,
            duration = data.duration
        })
    elseif Config.Notification == 'esx' then
        ESX.ShowNotification(data.message)
    end
end

RegisterNetEvent('zalco:notify', function(data)
    Notify(data)
end)

-- Item utilisable : tablette
exports('alcohol_tablet', function(data, slot)
    TriggerEvent('zalco:openTablet')
end)

-- Alerte police (blip sur la carte)
RegisterNetEvent('zalco:policeAlert', function(coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 1.2)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Vente d\'alcool illégale')
    EndTextCommandSetBlipName(blip)

    -- Faire clignoter le blip
    SetBlipFlashes(blip, true)

    -- Retirer le blip après 2 minutes
    SetTimeout(120000, function()
        RemoveBlip(blip)
    end)
end)

if Config.Debug then
    print('^2[ZALCO]^7 Client chargé !')
end
