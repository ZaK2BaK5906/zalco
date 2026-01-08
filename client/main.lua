ESX = exports['es_extended']:getSharedObject()
local currentLab = nil
local isBusy = false

-- Système de notifications 3D
local notifications = {}
local nextNotifId = 1

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

-- Variables pour le texte 3D
local helpText = {
    visible = false,
    message = '',
    key = 'E'
}

-- Fonction pour dessiner du texte 3D
local function Draw3DText(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextScale(0.4, 0.4)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Fonction pour afficher le texte 3D stylé
local function ShowStyledText(text, key)
    helpText.visible = true
    helpText.message = text
    helpText.key = key or 'E'
end

local function HideStyledText()
    helpText.visible = false
end

-- Thread pour afficher le texte 3D à côté de la tête
CreateThread(function()
    while true do
        Wait(0)
        if helpText.visible then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local boneCoords = GetPedBoneCoords(playerPed, 31086, 0.0, 0.0, 0.0) -- Head bone

            -- Position à côté de la tête
            local textCoords = vector3(boneCoords.x + 0.4, boneCoords.y, boneCoords.z + 0.3)

            -- Dessiner le cadre avec gradient (simulé avec plusieurs rectangles)
            local onScreen, screenX, screenY = World3dToScreen2d(textCoords.x, textCoords.y, textCoords.z)
            if onScreen then
                -- Fond du cadre
                DrawRect(screenX, screenY, 0.15, 0.045, 102, 126, 234, 240)

                -- Bordure
                DrawRect(screenX, screenY - 0.0235, 0.15, 0.002, 255, 255, 255, 100) -- Top
                DrawRect(screenX, screenY + 0.0235, 0.15, 0.002, 255, 255, 255, 100) -- Bottom

                -- Texte de la touche
                SetTextScale(0.35, 0.35)
                SetTextFont(4)
                SetTextProportional(1)
                SetTextColour(255, 255, 255, 255)
                SetTextOutline()
                SetTextEntry("STRING")
                SetTextCentre(1)
                AddTextComponentString('[' .. helpText.key .. ']')
                DrawText(screenX - 0.045, screenY - 0.012)

                -- Texte du message
                SetTextScale(0.3, 0.3)
                SetTextFont(4)
                SetTextProportional(1)
                SetTextColour(255, 255, 255, 255)
                SetTextOutline()
                SetTextEntry("STRING")
                SetTextCentre(1)
                AddTextComponentString(helpText.message)
                DrawText(screenX + 0.015, screenY - 0.012)
            end
        else
            Wait(500)
        end
    end
end)

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

-- Variables pour la progress bar custom
local progressBarActive = false
local progressBarData = {
    progress = 0,
    label = '',
    startTime = 0,
    duration = 0
}

-- Fonction de farming avec progress bar custom
function FarmItem(index, point)
    if isBusy then
        ShowNotification('Action en cours', 'Vous êtes déjà en train de faire quelque chose !', 'error')
        return
    end

    isBusy = true
    HideStyledText()
    local playerPed = PlayerPedId()

    -- Animation SANS téléportation (c'est ça qui cause le float)
    if point.animation then
        RequestAnimDict(point.animation.dict)
        while not HasAnimDictLoaded(point.animation.dict) do
            Wait(100)
        end
        -- Flag 49 = loop + upper body + cancelable = reste au sol
        TaskPlayAnim(playerPed, point.animation.dict, point.animation.anim, 8.0, -8.0, -1, 49, 0, false, false, false)
    end

    -- Progress bar custom 3D
    progressBarActive = true
    progressBarData.label = point.label
    progressBarData.startTime = GetGameTimer()
    progressBarData.duration = Config.FarmingTime
    progressBarData.progress = 0

    local cancelled = false

    -- Attendre la fin ou annulation
    while progressBarActive do
        Wait(0)

        -- Calculer progression
        local elapsed = GetGameTimer() - progressBarData.startTime
        progressBarData.progress = math.min(elapsed / progressBarData.duration, 1.0)

        -- Vérifier annulation
        if IsControlJustPressed(0, 73) then -- X key
            cancelled = true
            progressBarActive = false
        end

        -- Fin automatique
        if progressBarData.progress >= 1.0 then
            progressBarActive = false
        end
    end

    ClearPedTasks(playerPed)

    if not cancelled then
        TriggerServerEvent('zalco:farmItem', index)
    else
        ShowNotification('Annulé', 'Action annulée !', 'error')
    end

    isBusy = false
end

-- Thread pour afficher la progress bar 3D
CreateThread(function()
    while true do
        Wait(0)
        if progressBarActive then
            local playerPed = PlayerPedId()
            local boneCoords = GetPedBoneCoords(playerPed, 31086, 0.0, 0.0, 0.0)
            local onScreen, screenX, screenY = World3dToScreen2d(boneCoords.x, boneCoords.y, boneCoords.z + 0.5)

            if onScreen then
                -- Fond de la barre
                local barWidth = 0.15
                local barHeight = 0.02
                DrawRect(screenX, screenY, barWidth, barHeight, 30, 30, 30, 220)

                -- Barre de progression
                local progressWidth = barWidth * progressBarData.progress
                DrawRect(screenX - (barWidth - progressWidth) / 2, screenY, progressWidth, barHeight, 102, 126, 234, 255)

                -- Bordure
                DrawRect(screenX, screenY - barHeight/2 - 0.001, barWidth, 0.002, 255, 255, 255, 150) -- Top
                DrawRect(screenX, screenY + barHeight/2 + 0.001, barWidth, 0.002, 255, 255, 255, 150) -- Bottom
                DrawRect(screenX - barWidth/2 - 0.001, screenY, 0.002, barHeight, 255, 255, 255, 150) -- Left
                DrawRect(screenX + barWidth/2 + 0.001, screenY, 0.002, barHeight, 255, 255, 255, 150) -- Right

                -- Texte du label
                SetTextScale(0.3, 0.3)
                SetTextFont(4)
                SetTextProportional(1)
                SetTextColour(255, 255, 255, 255)
                SetTextOutline()
                SetTextEntry("STRING")
                SetTextCentre(1)
                AddTextComponentString(progressBarData.label)
                DrawText(screenX, screenY - 0.025)

                -- Pourcentage
                local percentage = math.floor(progressBarData.progress * 100)
                SetTextScale(0.25, 0.25)
                SetTextFont(4)
                SetTextProportional(1)
                SetTextColour(255, 255, 255, 255)
                SetTextOutline()
                SetTextEntry("STRING")
                SetTextCentre(1)
                AddTextComponentString(percentage .. '%')
                DrawText(screenX, screenY + 0.015)

                -- Aide annulation
                SetTextScale(0.2, 0.2)
                SetTextFont(4)
                SetTextProportional(1)
                SetTextColour(255, 255, 255, 180)
                SetTextOutline()
                SetTextEntry("STRING")
                SetTextCentre(1)
                AddTextComponentString('[X] Annuler')
                DrawText(screenX, screenY + 0.035)
            end
        else
            Wait(500)
        end
    end
end)

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

    -- Répondre immédiatement au NUI pour éviter l'erreur 404
    cb({success = true})

    -- Fermer l'UI
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({action = 'closeLab'})

    -- Animation (flag 49 pour rester au sol)
    RequestAnimDict('anim@amb@business@weed@weed_inspecting_high_dry@')
    while not HasAnimDictLoaded('anim@amb@business@weed@weed_inspecting_high_dry@') do
        Wait(100)
    end
    TaskPlayAnim(playerPed, 'anim@amb@business@weed@weed_inspecting_high_dry@', 'weed_inspecting_high_base_inspector', 8.0, -8.0, -1, 49, 0, false, false, false)

    -- Progress bar custom 3D
    progressBarActive = true
    progressBarData.label = 'Distillation en cours...'
    progressBarData.startTime = GetGameTimer()
    progressBarData.duration = alcohol.distillationTime
    progressBarData.progress = 0

    local cancelled = false

    -- Attendre la fin ou annulation
    while progressBarActive do
        Wait(0)

        -- Calculer progression
        local elapsed = GetGameTimer() - progressBarData.startTime
        progressBarData.progress = math.min(elapsed / progressBarData.duration, 1.0)

        -- Vérifier annulation
        if IsControlJustPressed(0, 73) then -- X key
            cancelled = true
            progressBarActive = false
        end

        -- Fin automatique
        if progressBarData.progress >= 1.0 then
            progressBarActive = false
        end
    end

    ClearPedTasks(playerPed)

    if not cancelled then
        TriggerServerEvent('zalco:processAlcohol', data.alcoholType, data.quality)
    else
        ShowNotification('Annulé', 'Distillation annulée !', 'error')
    end

    isBusy = false
end)

-- Vendre à un PNJ dans la rue

-- Fermer l'UI
RegisterNUICallback('closeUI', function(data, cb)
    cb({success = true})
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({action = 'closeAll'})
end)

-- Fermer avec ESC
RegisterNUICallback('escape', function(data, cb)
    cb({success = true})
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({action = 'closeAll'})
end)

-- Menu 3D pour voir les stats
local statsMenuOpen = false
local currentStats = nil

RegisterNetEvent('zalco:openTablet', function()
    lib.callback('zalco:getStats', false, function(stats)
        if not stats then
            ShowNotification('Erreur', 'Impossible de charger les statistiques', 'error')
            return
        end
        currentStats = stats
        statsMenuOpen = true
    end)
end)

-- Thread pour afficher le menu stats 3D
CreateThread(function()
    while true do
        Wait(0)
        if statsMenuOpen then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            -- Fermer avec ESC
            if IsControlJustPressed(0, 322) then -- ESC
                statsMenuOpen = false
                currentStats = nil
            end

            -- Position à droite de l'écran
            local screenX = 0.85
            local screenY = 0.25

            -- Fond
            DrawRect(screenX, screenY, 0.25, 0.5, 20, 20, 20, 220)

            -- Bordure violette
            DrawRect(screenX, screenY - 0.25, 0.25, 0.003, 102, 126, 234, 255) -- Top
            DrawRect(screenX, screenY + 0.25, 0.25, 0.003, 102, 126, 234, 255) -- Bottom
            DrawRect(screenX - 0.125, screenY, 0.003, 0.5, 102, 126, 234, 255) -- Left
            DrawRect(screenX + 0.125, screenY, 0.003, 0.5, 102, 126, 234, 255) -- Right

            -- Titre
            SetTextScale(0.45, 0.45)
            SetTextFont(4)
            SetTextProportional(1)
            SetTextColour(255, 255, 255, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            SetTextCentre(1)
            AddTextComponentString('~p~STATISTIQUES')
            DrawText(screenX, screenY - 0.23)

            -- Stats
            local yOffset = screenY - 0.15
            local lineHeight = 0.04

            -- Niveau
            SetTextScale(0.35, 0.35)
            SetTextFont(4)
            SetTextProportional(1)
            SetTextColour(102, 126, 234, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            SetTextCentre(0)
            AddTextComponentString('Niveau:')
            DrawText(screenX - 0.11, yOffset)

            SetTextColour(255, 255, 255, 255)
            AddTextComponentString(tostring(currentStats.level))
            DrawText(screenX + 0.05, yOffset)

            -- XP
            yOffset = yOffset + lineHeight
            SetTextColour(102, 126, 234, 255)
            AddTextComponentString('Expérience:')
            DrawText(screenX - 0.11, yOffset)

            SetTextColour(255, 255, 255, 255)
            AddTextComponentString(tostring(currentStats.experience))
            DrawText(screenX + 0.05, yOffset)

            -- Items farmés
            yOffset = yOffset + lineHeight
            SetTextColour(102, 126, 234, 255)
            AddTextComponentString('Items farmés:')
            DrawText(screenX - 0.11, yOffset)

            SetTextColour(255, 255, 255, 255)
            AddTextComponentString(tostring(currentStats.total_farmed))
            DrawText(screenX + 0.05, yOffset)

            -- Alcools produits
            yOffset = yOffset + lineHeight
            SetTextColour(102, 126, 234, 255)
            AddTextComponentString('Alcools produits:')
            DrawText(screenX - 0.11, yOffset)

            SetTextColour(255, 255, 255, 255)
            AddTextComponentString(tostring(currentStats.total_processed))
            DrawText(screenX + 0.05, yOffset)

            -- Alcools vendus
            yOffset = yOffset + lineHeight
            SetTextColour(102, 126, 234, 255)
            AddTextComponentString('Alcools vendus:')
            DrawText(screenX - 0.11, yOffset)

            SetTextColour(255, 255, 255, 255)
            AddTextComponentString(tostring(currentStats.total_sold))
            DrawText(screenX + 0.05, yOffset)

            -- Argent gagné
            yOffset = yOffset + lineHeight
            SetTextColour(102, 126, 234, 255)
            AddTextComponentString('Argent gagné:')
            DrawText(screenX - 0.11, yOffset)

            SetTextColour(46, 204, 113, 255) -- Vert
            AddTextComponentString(tostring(currentStats.money_earned) .. '$')
            DrawText(screenX + 0.05, yOffset)

            -- Message de fermeture
            yOffset = yOffset + lineHeight + 0.05
            SetTextScale(0.25, 0.25)
            SetTextColour(255, 255, 255, 180)
            AddTextComponentString('[ESC] Fermer')
            DrawText(screenX, yOffset)

        else
            Wait(500)
        end
    end
end)

-- Système de notifications 3D custom
function ShowNotification(title, message, notifType)
    local id = nextNotifId
    nextNotifId = nextNotifId + 1

    -- Couleur selon le type
    local color = {r = 102, g = 126, b = 234} -- default (bleu)
    if notifType == 'error' then
        color = {r = 231, g = 76, b = 60} -- rouge
    elseif notifType == 'success' then
        color = {r = 46, g = 204, b = 113} -- vert
    elseif notifType == 'warning' then
        color = {r = 241, g = 196, b = 15} -- jaune
    end

    notifications[id] = {
        title = title,
        message = message,
        color = color,
        startTime = GetGameTimer(),
        duration = 4000,
        alpha = 0
    }

    -- Fade in
    CreateThread(function()
        local notif = notifications[id]
        if not notif then return end

        -- Fade in
        for i = 0, 255, 15 do
            if not notifications[id] then break end
            notifications[id].alpha = i
            Wait(10)
        end

        if notifications[id] then
            notifications[id].alpha = 255
        end

        -- Attendre
        Wait(notif.duration - 500)

        -- Fade out
        if notifications[id] then
            for i = 255, 0, -15 do
                if not notifications[id] then break end
                notifications[id].alpha = i
                Wait(10)
            end
        end

        -- Supprimer
        notifications[id] = nil
    end)
end

-- Compatibilité avec l'ancien système Notify
function Notify(data)
    ShowNotification(data.title or 'Notification', data.message or '', data.type or 'info')
end

RegisterNetEvent('zalco:notify', function(data)
    Notify(data)
end)

-- Thread pour afficher les notifications 3D
CreateThread(function()
    while true do
        Wait(0)
        if next(notifications) then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local camCoords = GetGameplayCamCoord()

            local offsetIndex = 0
            for id, notif in pairs(notifications) do
                -- Position à droite de l'écran en haut
                local notifCoords = vector3(
                    playerCoords.x + 2.0,
                    playerCoords.y,
                    playerCoords.z + 1.5 - (offsetIndex * 0.25)
                )

                local onScreen, screenX, screenY = World3dToScreen2d(notifCoords.x, notifCoords.y, notifCoords.z)

                -- Forcer à droite de l'écran
                screenX = 0.85
                screenY = 0.15 + (offsetIndex * 0.08)

                -- Fond de la notification
                local width = 0.2
                local height = 0.06
                DrawRect(screenX, screenY, width, height, 20, 20, 20, math.floor(notif.alpha * 0.9))

                -- Barre de couleur à gauche
                DrawRect(screenX - width/2 + 0.003, screenY, 0.006, height, notif.color.r, notif.color.g, notif.color.b, notif.alpha)

                -- Bordure
                DrawRect(screenX, screenY - height/2, width, 0.002, 255, 255, 255, math.floor(notif.alpha * 0.5))
                DrawRect(screenX, screenY + height/2, width, 0.002, 255, 255, 255, math.floor(notif.alpha * 0.5))

                -- Titre
                SetTextScale(0.35, 0.35)
                SetTextFont(4)
                SetTextProportional(1)
                SetTextColour(255, 255, 255, notif.alpha)
                SetTextOutline()
                SetTextEntry("STRING")
                SetTextCentre(0)
                AddTextComponentString(notif.title)
                DrawText(screenX - width/2 + 0.015, screenY - 0.018)

                -- Message
                SetTextScale(0.25, 0.25)
                SetTextFont(4)
                SetTextProportional(1)
                SetTextColour(200, 200, 200, notif.alpha)
                SetTextOutline()
                SetTextEntry("STRING")
                SetTextCentre(0)
                AddTextComponentString(notif.message)
                DrawText(screenX - width/2 + 0.015, screenY + 0.005)

                offsetIndex = offsetIndex + 1
            end
        else
            Wait(500)
        end
    end
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
