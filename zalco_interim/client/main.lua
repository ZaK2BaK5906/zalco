-- =============================================================================
-- ZALCO INTERIM - CLIENT SIDE
-- Systeme de jobs interimaires full 3D UI
-- =============================================================================

local ESX = exports['es_extended']:getSharedObject()

-- Variables globales
local PlayerData = {}
local isWorking = false
local currentJob = nil
local currentShift = {
    job = nil,
    startTime = 0,
    earnings = 0,
    tasksCompleted = 0,
    collectedBags = 0, -- Pour eboueur
    deliveries = {}, -- Pour livreur/facteur
}

-- 3D UI State
local progressBarData = nil
local notifications = {}
local notificationId = 0

-- Blips
local jobBlips = {}

-- Spawned vehicles/props
local spawnedVehicle = nil
local spawnedProp = nil

-- Missions illegales
local illegalMission = {
    active = false,
    pending = false, -- En attente de decision Y/N
    data = nil,
    blip = nil,
    startTime = 0,
    lastCheck = 0,
    lastMissionTime = 0,
}

-- Debug
local function DebugPrint(msg)
    if Config.Debug then
        print('[ZALCO_INTERIM] ' .. msg)
    end
end

-- =============================================================================
-- INITIALISATION
-- =============================================================================

CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Wait(100)
    end
    PlayerData = ESX.GetPlayerData()

    -- Creer les blips pour tous les jobs
    CreateJobBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    CreateJobBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

-- =============================================================================
-- BLIPS CREATION
-- =============================================================================

function CreateJobBlips()
    -- Supprimer anciens blips
    for _, blip in pairs(jobBlips) do
        RemoveBlip(blip)
    end
    jobBlips = {}

    -- Creer blips pour chaque job
    for jobId, jobData in pairs(Config.Jobs) do
        local blip = AddBlipForCoord(jobData.startPoint.x, jobData.startPoint.y, jobData.startPoint.z)
        SetBlipSprite(blip, jobData.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, jobData.blip.scale)
        SetBlipColour(blip, jobData.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(jobData.blip.label)
        EndTextCommandSetBlipName(blip)

        jobBlips[jobId] = blip
    end
end

-- =============================================================================
-- 3D TEXT UI - ATTACHE AUX BONES
-- =============================================================================

function Draw3DText(coords, text, scale, backgroundColor, textColor)
    local onScreen, screenX, screenY = World3dToScreen2d(coords.x, coords.y, coords.z)

    if onScreen then
        local camCoords = GetGameplayCamCoords()
        local distance = #(camCoords - coords)

        scale = scale or 0.35
        local fov = (1 / GetGameplayCamFov()) * 100
        local scaleMultiplier = scale * fov * (1 / distance) * 2

        if scaleMultiplier > scale then scaleMultiplier = scale end
        if scaleMultiplier < scale * 0.5 then scaleMultiplier = scale * 0.5 end

        -- Background
        if backgroundColor then
            local textWidth = string.len(text) * 0.005 * scaleMultiplier
            DrawRect(screenX, screenY, textWidth + 0.015, 0.025 * scaleMultiplier + 0.01,
                backgroundColor[1], backgroundColor[2], backgroundColor[3], 200)
            -- Bordure
            DrawRect(screenX, screenY - (0.025 * scaleMultiplier + 0.01) / 2 - 0.002, textWidth + 0.015, 0.004,
                Config.Colors.primary[1], Config.Colors.primary[2], Config.Colors.primary[3], 255)
        end

        -- Texte
        SetTextScale(scaleMultiplier, scaleMultiplier)
        SetTextFont(4)
        SetTextColour(textColor and textColor[1] or 255, textColor and textColor[2] or 255, textColor and textColor[3] or 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(true)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(screenX, screenY - 0.0125 * scaleMultiplier)
    end
end

function Draw3DTextOnBone(ped, text, offsetX, offsetY, offsetZ)
    local boneCoords = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.0) -- 31086 = HEAD
    local textCoords = vector3(boneCoords.x + (offsetX or 0.0), boneCoords.y + (offsetY or 0.0), boneCoords.z + (offsetZ or 0.5))

    local onScreen, screenX, screenY = World3dToScreen2d(textCoords.x, textCoords.y, textCoords.z)

    if onScreen then
        local camCoords = GetGameplayCamCoords()
        local distance = #(camCoords - textCoords)

        local scale = 0.35
        local fov = (1 / GetGameplayCamFov()) * 100
        local scaleMultiplier = scale * fov * (1 / distance) * 2

        if scaleMultiplier > 0.4 then scaleMultiplier = 0.4 end
        if scaleMultiplier < 0.2 then scaleMultiplier = 0.2 end

        local textWidth = string.len(text) * 0.0045 * scaleMultiplier
        local boxHeight = 0.022 * scaleMultiplier + 0.008

        -- Background box
        DrawRect(screenX, screenY, textWidth + 0.02, boxHeight, 20, 20, 30, 220)

        -- Accent bar (left side)
        DrawRect(screenX - (textWidth + 0.02) / 2 + 0.003, screenY, 0.006, boxHeight,
            Config.Colors.primary[1], Config.Colors.primary[2], Config.Colors.primary[3], 255)

        -- Border top
        DrawRect(screenX, screenY - boxHeight / 2, textWidth + 0.02, 0.002,
            Config.Colors.primary[1], Config.Colors.primary[2], Config.Colors.primary[3], 200)

        -- Text
        SetTextScale(scaleMultiplier, scaleMultiplier)
        SetTextFont(4)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextCentre(true)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(screenX + 0.003, screenY - 0.008 * scaleMultiplier)
    end
end

-- =============================================================================
-- 3D PROGRESS BAR
-- =============================================================================

function StartProgressBar(label, duration, canCancel)
    progressBarData = {
        label = label,
        duration = duration,
        startTime = GetGameTimer(),
        canCancel = canCancel ~= false,
        cancelled = false
    }
end

function StopProgressBar()
    progressBarData = nil
end

function IsProgressBarActive()
    return progressBarData ~= nil
end

function IsProgressBarCancelled()
    return progressBarData and progressBarData.cancelled
end

-- Thread de rendu progress bar
CreateThread(function()
    while true do
        if progressBarData then
            local playerPed = PlayerPedId()
            local boneCoords = GetPedBoneCoords(playerPed, 31086, 0.0, 0.0, 0.0)
            local barCoords = vector3(boneCoords.x, boneCoords.y, boneCoords.z + 0.35)

            local onScreen, screenX, screenY = World3dToScreen2d(barCoords.x, barCoords.y, barCoords.z)

            if onScreen then
                local elapsed = GetGameTimer() - progressBarData.startTime
                local progress = math.min(elapsed / progressBarData.duration, 1.0)
                local percent = math.floor(progress * 100)

                local barWidth = 0.08
                local barHeight = 0.012
                local progressWidth = barWidth * progress

                -- Background bar
                DrawRect(screenX, screenY, barWidth + 0.006, barHeight + 0.008, 20, 20, 30, 230)

                -- Empty bar
                DrawRect(screenX, screenY, barWidth, barHeight, 40, 40, 50, 255)

                -- Progress fill
                DrawRect(screenX - (barWidth - progressWidth) / 2, screenY, progressWidth, barHeight,
                    Config.Colors.primary[1], Config.Colors.primary[2], Config.Colors.primary[3], 255)

                -- Border
                DrawRect(screenX, screenY - barHeight / 2 - 0.003, barWidth + 0.006, 0.002,
                    Config.Colors.primary[1], Config.Colors.primary[2], Config.Colors.primary[3], 200)

                -- Label text
                SetTextScale(0.28, 0.28)
                SetTextFont(4)
                SetTextColour(255, 255, 255, 255)
                SetTextCentre(true)
                SetTextEntry("STRING")
                AddTextComponentString(progressBarData.label .. ' - ' .. percent .. '%')
                DrawText(screenX, screenY - 0.025)

                -- Cancel hint
                if progressBarData.canCancel then
                    SetTextScale(0.22, 0.22)
                    SetTextFont(4)
                    SetTextColour(200, 200, 200, 200)
                    SetTextCentre(true)
                    SetTextEntry("STRING")
                    AddTextComponentString('[X] Annuler')
                    DrawText(screenX, screenY + 0.012)

                    if IsControlJustPressed(0, 73) then -- X key
                        progressBarData.cancelled = true
                    end
                end
            end

            Wait(0)
        else
            Wait(500)
        end
    end
end)

-- =============================================================================
-- 3D NOTIFICATIONS
-- =============================================================================

function ShowNotification3D(message, type, duration)
    notificationId = notificationId + 1

    local colors = {
        ['info'] = Config.Colors.primary,
        ['success'] = Config.Colors.success,
        ['error'] = Config.Colors.error,
        ['warning'] = Config.Colors.warning,
    }

    local notif = {
        id = notificationId,
        message = message,
        type = type or 'info',
        color = colors[type] or colors['info'],
        startTime = GetGameTimer(),
        duration = duration or 4000,
        alpha = 0,
        state = 'fadein'
    }

    table.insert(notifications, notif)
end

-- Export pour autres scripts
exports('ShowNotification3D', ShowNotification3D)

-- Event pour notifications depuis le serveur
RegisterNetEvent('zalco_interim:notify')
AddEventHandler('zalco_interim:notify', function(message, type)
    ShowNotification3D(message, type, 4000)
end)

-- Event pour alerte police
RegisterNetEvent('zalco_interim:policeAlert')
AddEventHandler('zalco_interim:policeAlert', function(coords, message)
    -- Creer blip temporaire pour les flics
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 1)
    SetBlipFlashes(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(message or "Activite suspecte")
    EndTextCommandSetBlipName(blip)

    ShowNotification3D(message or "Activite suspecte signalee!", 'warning', 8000)
    PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", true)

    -- Supprimer blip apres 60 secondes
    SetTimeout(60000, function()
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end)
end)

-- Event pour level up
RegisterNetEvent('zalco_interim:levelUp')
AddEventHandler('zalco_interim:levelUp', function(jobId, newLevel, levelName)
    ShowNotification3D('NIVEAU SUPERIEUR! Tu es maintenant ' .. levelName, 'success', 6000)
    PlaySoundFrontend(-1, "MEDAL_UP", "HUD_MINI_GAME_SOUNDSET", true)
end)

-- Thread de rendu notifications
CreateThread(function()
    while true do
        if #notifications > 0 then
            local currentTime = GetGameTimer()
            local toRemove = {}

            for i, notif in ipairs(notifications) do
                local elapsed = currentTime - notif.startTime

                -- Gestion des etats
                if notif.state == 'fadein' then
                    notif.alpha = math.min(255, notif.alpha + 15)
                    if notif.alpha >= 255 then
                        notif.state = 'visible'
                    end
                elseif notif.state == 'visible' then
                    if elapsed > notif.duration - 300 then
                        notif.state = 'fadeout'
                    end
                elseif notif.state == 'fadeout' then
                    notif.alpha = math.max(0, notif.alpha - 15)
                    if notif.alpha <= 0 then
                        table.insert(toRemove, i)
                    end
                end

                -- Rendu
                if notif.alpha > 0 then
                    local screenX = 0.85
                    local screenY = 0.12 + ((i - 1) * 0.065)
                    local width = 0.18
                    local height = 0.04

                    -- Background
                    DrawRect(screenX, screenY, width, height, 20, 20, 30, math.floor(notif.alpha * 0.9))

                    -- Color accent bar
                    DrawRect(screenX - width / 2 + 0.004, screenY, 0.008, height,
                        notif.color[1], notif.color[2], notif.color[3], notif.alpha)

                    -- Border top
                    DrawRect(screenX, screenY - height / 2, width, 0.002,
                        notif.color[1], notif.color[2], notif.color[3], math.floor(notif.alpha * 0.7))

                    -- Text
                    SetTextScale(0.28, 0.28)
                    SetTextFont(4)
                    SetTextColour(255, 255, 255, notif.alpha)
                    SetTextCentre(true)
                    SetTextEntry("STRING")
                    AddTextComponentString(notif.message)
                    DrawText(screenX + 0.005, screenY - 0.012)
                end
            end

            -- Supprimer notifications terminees
            for i = #toRemove, 1, -1 do
                table.remove(notifications, toRemove[i])
            end

            Wait(0)
        else
            Wait(500)
        end
    end
end)

-- =============================================================================
-- MAIN INTERACTION LOOP
-- =============================================================================

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for jobId, jobData in pairs(Config.Jobs) do
            local distToStart = #(playerCoords - jobData.startPoint)

            -- Affichage point de depart
            if distToStart < Config.DrawDistance then
                sleep = 0

                if distToStart < Config.InteractDistance then
                    Draw3DTextOnBone(playerPed, '[E] ' .. jobData.label, 0.0, 0.0, 0.6)

                    if not isWorking and IsControlJustPressed(0, 38) then -- E key
                        StartJob(jobId)
                    end
                else
                    Draw3DText(jobData.startPoint + vector3(0, 0, 1.0), jobData.label, 0.4, Config.Colors.background, Config.Colors.white)
                end
            end

            -- Si on travaille ce job, afficher les points de farm/livraison/etc
            if isWorking and currentJob == jobId then
                sleep = 0
                DrawJobPoints(jobId, jobData, playerPed, playerCoords)
            end
        end

        Wait(sleep)
    end
end)

-- =============================================================================
-- JOB POINTS DRAWING & INTERACTION
-- =============================================================================

function DrawJobPoints(jobId, jobData, playerPed, playerCoords)
    -- Jobs de farm (mineur, bucheron, boucher)
    if jobData.farmPoints then
        for i, point in ipairs(jobData.farmPoints) do
            local dist = #(playerCoords - point.coords)

            if dist < Config.DrawDistance then
                if dist < Config.InteractDistance then
                    Draw3DTextOnBone(playerPed, '[E] ' .. point.label, 0.0, 0.0, 0.6)

                    if not IsProgressBarActive() and IsControlJustPressed(0, 38) then
                        DoFarmAction(jobId, jobData, point, i)
                    end
                else
                    Draw3DText(point.coords + vector3(0, 0, 0.8), point.label, 0.35, Config.Colors.background, Config.Colors.white)
                end
            end
        end

        -- Point de vente
        if jobData.sellPoint then
            local dist = #(playerCoords - jobData.sellPoint.coords)
            if dist < Config.DrawDistance then
                if dist < Config.InteractDistance then
                    Draw3DTextOnBone(playerPed, '[E] ' .. jobData.sellPoint.label, 0.0, 0.0, 0.6)

                    if not IsProgressBarActive() and IsControlJustPressed(0, 38) then
                        SellItems(jobId, jobData)
                    end
                else
                    Draw3DText(jobData.sellPoint.coords + vector3(0, 0, 0.8), jobData.sellPoint.label, 0.35, {46, 204, 113}, Config.Colors.white)
                end
            end
        end
    end

    -- Jobs de livraison (pizza, facteur)
    if jobData.deliveryPoints then
        -- Point de recuperation
        if jobData.deliveryPickup then
            local dist = #(playerCoords - jobData.deliveryPickup.coords)
            if dist < Config.DrawDistance then
                if dist < Config.InteractDistance then
                    Draw3DTextOnBone(playerPed, '[E] ' .. jobData.deliveryPickup.label, 0.0, 0.0, 0.6)

                    if not IsProgressBarActive() and IsControlJustPressed(0, 38) and #currentShift.deliveries == 0 then
                        PickupDeliveries(jobId, jobData)
                    end
                else
                    Draw3DText(jobData.deliveryPickup.coords + vector3(0, 0, 0.8), jobData.deliveryPickup.label, 0.35, Config.Colors.background, Config.Colors.white)
                end
            end
        end

        -- Points de livraison actifs
        for i, delivery in ipairs(currentShift.deliveries) do
            if not delivery.completed then
                local dist = #(playerCoords - delivery.coords)
                if dist < Config.DrawDistance then
                    if dist < Config.InteractDistance then
                        Draw3DTextOnBone(playerPed, '[E] ' .. delivery.label, 0.0, 0.0, 0.6)

                        if not IsProgressBarActive() and IsControlJustPressed(0, 38) then
                            DoDelivery(jobId, jobData, delivery, i)
                        end
                    else
                        Draw3DText(delivery.coords + vector3(0, 0, 0.8), 'Livraison #' .. i, 0.35, {255, 183, 77}, Config.Colors.white)
                    end
                end
            end
        end
    end

    -- Eboueur
    if jobData.collectPoints then
        for i, point in ipairs(jobData.collectPoints) do
            local dist = #(playerCoords - point.coords)

            if dist < Config.DrawDistance then
                if dist < Config.InteractDistance then
                    Draw3DTextOnBone(playerPed, '[E] ' .. point.label, 0.0, 0.0, 0.6)

                    if not IsProgressBarActive() and IsControlJustPressed(0, 38) then
                        DoCollectTrash(jobId, jobData, point, i)
                    end
                else
                    Draw3DText(point.coords + vector3(0, 0, 0.8), point.label, 0.35, Config.Colors.background, Config.Colors.white)
                end
            end
        end

        -- Point de depot
        if jobData.depositPoint then
            local dist = #(playerCoords - jobData.depositPoint.coords)
            if dist < Config.DrawDistance then
                local bagsText = currentShift.collectedBags .. ' sacs'
                if dist < Config.InteractDistance then
                    Draw3DTextOnBone(playerPed, '[E] Deposer (' .. bagsText .. ')', 0.0, 0.0, 0.6)

                    if not IsProgressBarActive() and IsControlJustPressed(0, 38) and currentShift.collectedBags > 0 then
                        DepositTrash(jobId, jobData)
                    end
                else
                    Draw3DText(jobData.depositPoint.coords + vector3(0, 0, 0.8), 'Depot - ' .. bagsText, 0.35, {46, 204, 113}, Config.Colors.white)
                end
            end
        end
    end

    -- Agent entretien
    if jobData.cleanPoints then
        for i, point in ipairs(jobData.cleanPoints) do
            local dist = #(playerCoords - point.coords)

            if dist < Config.DrawDistance then
                if dist < Config.InteractDistance then
                    Draw3DTextOnBone(playerPed, '[E] ' .. point.label, 0.0, 0.0, 0.6)

                    if not IsProgressBarActive() and IsControlJustPressed(0, 38) then
                        DoCleanAction(jobId, jobData, point, i)
                    end
                else
                    Draw3DText(point.coords + vector3(0, 0, 0.8), point.label, 0.35, Config.Colors.background, Config.Colors.white)
                end
            end
        end
    end

    -- Jardinier
    if jobData.gardenPoints then
        for i, point in ipairs(jobData.gardenPoints) do
            local dist = #(playerCoords - point.coords)

            if dist < Config.DrawDistance then
                if dist < Config.InteractDistance then
                    Draw3DTextOnBone(playerPed, '[E] ' .. point.label, 0.0, 0.0, 0.6)

                    if not IsProgressBarActive() and IsControlJustPressed(0, 38) then
                        DoGardenAction(jobId, jobData, point, i)
                    end
                else
                    Draw3DText(point.coords + vector3(0, 0, 0.8), point.label, 0.35, Config.Colors.background, Config.Colors.white)
                end
            end
        end
    end
end

-- =============================================================================
-- JOB START/STOP
-- =============================================================================

-- =============================================================================
-- CHECK REQUIRED TOOLS
-- =============================================================================

function HasRequiredTool(jobId)
    local jobData = Config.Jobs[jobId]
    if not jobData then return false end

    -- Check pickaxe pour mineur
    if jobData.requiredItem then
        local hasItem = exports.ox_inventory:Search('count', jobData.requiredItem) > 0
        if not hasItem then
            ShowNotification3D('Tu as besoin d\'une ' .. jobData.requiredItem .. '!', 'error', 4000)
            return false
        end
    end

    -- Check haches pour bucheron
    if jobData.requiredAxes then
        local hasAxe = false
        for _, axe in ipairs(jobData.requiredAxes) do
            if exports.ox_inventory:Search('count', axe) > 0 then
                hasAxe = true
                break
            end
        end
        if not hasAxe then
            ShowNotification3D('Tu as besoin d\'une hache!', 'error', 4000)
            return false
        end
    end

    return true
end

function StartJob(jobId)
    local jobData = Config.Jobs[jobId]
    if not jobData then return end

    -- Check outils requis
    if not HasRequiredTool(jobId) then
        return
    end

    isWorking = true
    currentJob = jobId
    currentShift = {
        job = jobId,
        startTime = GetGameTimer(),
        earnings = 0,
        tasksCompleted = 0,
        collectedBags = 0,
        deliveries = {},
    }

    ShowNotification3D('Shift ' .. jobData.label .. ' commence!', 'success', 5000)

    -- Spawn vehicule si necessaire
    if jobData.vehicle then
        SpawnJobVehicle(jobData.vehicle)
    end

    -- Creer blips pour les points de travail
    CreateWorkBlips(jobId, jobData)

    TriggerServerEvent('zalco_interim:startShift', jobId)
end

function StopJob()
    if not isWorking then return end

    local jobData = Config.Jobs[currentJob]
    local shiftDuration = math.floor((GetGameTimer() - currentShift.startTime) / 60000)

    ShowNotification3D('Shift termine! +$' .. currentShift.earnings .. ' (' .. currentShift.tasksCompleted .. ' taches)', 'success', 6000)

    -- Supprimer vehicule
    if spawnedVehicle and DoesEntityExist(spawnedVehicle) then
        DeleteEntity(spawnedVehicle)
        spawnedVehicle = nil
    end

    -- Supprimer blips de travail
    RemoveWorkBlips()

    TriggerServerEvent('zalco_interim:endShift', currentJob, currentShift.earnings, currentShift.tasksCompleted)

    isWorking = false
    currentJob = nil
    currentShift = {
        job = nil,
        startTime = 0,
        earnings = 0,
        tasksCompleted = 0,
        collectedBags = 0,
        deliveries = {},
    }
end

-- Commande pour arreter le job
RegisterCommand('stopjob', function()
    if isWorking then
        StopJob()
    else
        ShowNotification3D('Tu n\'es pas en shift!', 'error', 3000)
    end
end)

-- =============================================================================
-- WORK BLIPS
-- =============================================================================

local workBlips = {}

function CreateWorkBlips(jobId, jobData)
    RemoveWorkBlips()

    -- Blips pour points de farm
    if jobData.farmPoints then
        for i, point in ipairs(jobData.farmPoints) do
            local blip = AddBlipForCoord(point.coords.x, point.coords.y, point.coords.z)
            SetBlipSprite(blip, 164)
            SetBlipScale(blip, 0.6)
            SetBlipColour(blip, 5)
            SetBlipAsShortRange(blip, true)
            table.insert(workBlips, blip)
        end

        if jobData.sellPoint then
            local blip = AddBlipForCoord(jobData.sellPoint.coords.x, jobData.sellPoint.coords.y, jobData.sellPoint.coords.z)
            SetBlipSprite(blip, 500)
            SetBlipScale(blip, 0.7)
            SetBlipColour(blip, 2)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Vente")
            EndTextCommandSetBlipName(blip)
            table.insert(workBlips, blip)
        end
    end

    -- Blips pour points de collecte (eboueur)
    if jobData.collectPoints then
        for i, point in ipairs(jobData.collectPoints) do
            local blip = AddBlipForCoord(point.coords.x, point.coords.y, point.coords.z)
            SetBlipSprite(blip, 164)
            SetBlipScale(blip, 0.5)
            SetBlipColour(blip, 21)
            SetBlipAsShortRange(blip, true)
            table.insert(workBlips, blip)
        end

        if jobData.depositPoint then
            local blip = AddBlipForCoord(jobData.depositPoint.coords.x, jobData.depositPoint.coords.y, jobData.depositPoint.coords.z)
            SetBlipSprite(blip, 500)
            SetBlipScale(blip, 0.7)
            SetBlipColour(blip, 2)
            SetBlipAsShortRange(blip, true)
            table.insert(workBlips, blip)
        end
    end

    -- Blips pour points de nettoyage
    if jobData.cleanPoints then
        for i, point in ipairs(jobData.cleanPoints) do
            local blip = AddBlipForCoord(point.coords.x, point.coords.y, point.coords.z)
            SetBlipSprite(blip, 164)
            SetBlipScale(blip, 0.5)
            SetBlipColour(blip, 26)
            SetBlipAsShortRange(blip, true)
            table.insert(workBlips, blip)
        end
    end

    -- Blips pour points de jardinage
    if jobData.gardenPoints then
        for i, point in ipairs(jobData.gardenPoints) do
            local blip = AddBlipForCoord(point.coords.x, point.coords.y, point.coords.z)
            SetBlipSprite(blip, 164)
            SetBlipScale(blip, 0.5)
            SetBlipColour(blip, 25)
            SetBlipAsShortRange(blip, true)
            table.insert(workBlips, blip)
        end
    end

    -- Blips pour livraisons
    if jobData.deliveryPickup then
        local blip = AddBlipForCoord(jobData.deliveryPickup.coords.x, jobData.deliveryPickup.coords.y, jobData.deliveryPickup.coords.z)
        SetBlipSprite(blip, 478)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 5)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Recuperer commandes")
        EndTextCommandSetBlipName(blip)
        table.insert(workBlips, blip)
    end
end

function RemoveWorkBlips()
    for _, blip in pairs(workBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    workBlips = {}
end

function AddDeliveryBlips(deliveries)
    for i, delivery in ipairs(deliveries) do
        local blip = AddBlipForCoord(delivery.coords.x, delivery.coords.y, delivery.coords.z)
        SetBlipSprite(blip, 1)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 5)
        SetBlipAsShortRange(blip, false)
        SetBlipRoute(blip, i == 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Livraison #" .. i)
        EndTextCommandSetBlipName(blip)
        delivery.blip = blip
        table.insert(workBlips, blip)
    end
end

-- =============================================================================
-- VEHICLE SPAWNING
-- =============================================================================

function SpawnJobVehicle(vehicleData)
    local modelHash = GetHashKey(vehicleData.model)

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(100)
    end

    local vehicle = CreateVehicle(modelHash, vehicleData.spawnPoint.x, vehicleData.spawnPoint.y, vehicleData.spawnPoint.z, vehicleData.spawnPoint.w, true, false)

    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleDoorsLocked(vehicle, 0)
    SetModelAsNoLongerNeeded(modelHash)

    -- Donner les cles
    TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(vehicle))

    spawnedVehicle = vehicle

    ShowNotification3D('Vehicule de travail spawne!', 'info', 3000)
end

-- =============================================================================
-- PROP HANDLING
-- =============================================================================

function AttachProp(propData)
    if spawnedProp and DoesEntityExist(spawnedProp) then
        DeleteEntity(spawnedProp)
    end

    local playerPed = PlayerPedId()
    local modelHash = GetHashKey(propData.model)

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(100)
    end

    local prop = CreateObject(modelHash, 0, 0, 0, true, true, true)
    AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, propData.bone),
        propData.offset.x, propData.offset.y, propData.offset.z,
        propData.rotation.x, propData.rotation.y, propData.rotation.z,
        true, true, false, true, 1, true)

    SetModelAsNoLongerNeeded(modelHash)
    spawnedProp = prop
end

function RemoveProp()
    if spawnedProp and DoesEntityExist(spawnedProp) then
        DeleteEntity(spawnedProp)
        spawnedProp = nil
    end
end

-- =============================================================================
-- FARM ACTIONS (Mineur, Bucheron, Boucher)
-- =============================================================================

function DoFarmAction(jobId, jobData, point, pointIndex)
    local playerPed = PlayerPedId()

    -- Attacher prop si existe
    if jobData.prop then
        AttachProp(jobData.prop)
    end

    -- Animation
    RequestAnimDict(jobData.animation.dict)
    while not HasAnimDictLoaded(jobData.animation.dict) do
        Wait(100)
    end

    TaskPlayAnim(playerPed, jobData.animation.dict, jobData.animation.anim, 8.0, -8.0, -1, jobData.animation.flag, 0, false, false, false)

    -- Progress bar
    StartProgressBar(point.label, point.time, true)

    -- Attendre fin
    local startTime = GetGameTimer()
    while GetGameTimer() - startTime < point.time do
        if IsProgressBarCancelled() then
            StopProgressBar()
            ClearPedTasks(playerPed)
            RemoveProp()
            ShowNotification3D('Action annulee', 'warning', 2000)
            return
        end
        Wait(100)
    end

    StopProgressBar()
    ClearPedTasks(playerPed)
    RemoveProp()

    -- Donner items via serveur
    TriggerServerEvent('zalco_interim:farmItem', jobId, point.item, point.minAmount, point.maxAmount)

    currentShift.tasksCompleted = currentShift.tasksCompleted + 1
    ShowNotification3D('+' .. point.item, 'success', 2000)
end

-- =============================================================================
-- SELL ITEMS
-- =============================================================================

function SellItems(jobId, jobData)
    lib.callback('zalco_interim:sellItems', false, function(result)
        if result and result.success then
            currentShift.earnings = currentShift.earnings + result.total
            ShowNotification3D('Vendu! +$' .. result.total, 'success', 3000)
        elseif result and result.message then
            ShowNotification3D(result.message, 'error', 3000)
        end
    end, jobId)
end

-- =============================================================================
-- DELIVERY ACTIONS (Pizza, Facteur)
-- =============================================================================

function PickupDeliveries(jobId, jobData)
    local playerPed = PlayerPedId()

    -- Animation
    RequestAnimDict(jobData.animation.dict)
    while not HasAnimDictLoaded(jobData.animation.dict) do
        Wait(100)
    end

    TaskPlayAnim(playerPed, jobData.animation.dict, jobData.animation.anim, 8.0, -8.0, 2000, jobData.animation.flag, 0, false, false, false)

    StartProgressBar('Recuperation commandes...', 3000, false)
    Wait(3000)
    StopProgressBar()

    -- Selectionner 3-5 livraisons aleatoires
    local numDeliveries = math.random(3, 5)
    local availablePoints = {}

    for i, point in ipairs(jobData.deliveryPoints) do
        table.insert(availablePoints, {index = i, data = point})
    end

    -- Shuffle et prendre les premieres
    for i = #availablePoints, 2, -1 do
        local j = math.random(1, i)
        availablePoints[i], availablePoints[j] = availablePoints[j], availablePoints[i]
    end

    currentShift.deliveries = {}
    for i = 1, math.min(numDeliveries, #availablePoints) do
        local point = availablePoints[i].data
        table.insert(currentShift.deliveries, {
            coords = point.coords,
            label = point.label,
            reward = point.reward,
            time = point.time,
            completed = false,
            startTime = GetGameTimer(),
        })
    end

    AddDeliveryBlips(currentShift.deliveries)

    ShowNotification3D(#currentShift.deliveries .. ' livraisons a effectuer!', 'info', 4000)
end

function DoDelivery(jobId, jobData, delivery, deliveryIndex)
    local playerPed = PlayerPedId()

    -- Animation
    RequestAnimDict(jobData.animation.dict)
    while not HasAnimDictLoaded(jobData.animation.dict) do
        Wait(100)
    end

    TaskPlayAnim(playerPed, jobData.animation.dict, jobData.animation.anim, 8.0, -8.0, -1, jobData.animation.flag, 0, false, false, false)

    StartProgressBar(delivery.label, delivery.time, true)

    local startTime = GetGameTimer()
    while GetGameTimer() - startTime < delivery.time do
        if IsProgressBarCancelled() then
            StopProgressBar()
            ClearPedTasks(playerPed)
            ShowNotification3D('Livraison annulee', 'warning', 2000)
            return
        end
        Wait(100)
    end

    StopProgressBar()
    ClearPedTasks(playerPed)

    -- Calculer bonus temps
    local reward = delivery.reward
    local deliveryTime = (GetGameTimer() - delivery.startTime) / 1000

    if jobData.bonusTime and deliveryTime < jobData.bonusTime then
        reward = reward + (jobData.bonusAmount or 50)
        ShowNotification3D('Bonus rapidite! +$' .. (jobData.bonusAmount or 50), 'success', 2000)
    end

    delivery.completed = true
    currentShift.earnings = currentShift.earnings + reward
    currentShift.tasksCompleted = currentShift.tasksCompleted + 1

    -- Supprimer blip de cette livraison
    if delivery.blip and DoesBlipExist(delivery.blip) then
        RemoveBlip(delivery.blip)
    end

    ShowNotification3D('Livraison complete! +$' .. reward, 'success', 3000)

    TriggerServerEvent('zalco_interim:deliveryComplete', jobId, reward)

    -- Verifier si toutes les livraisons sont faites
    local allDone = true
    for _, d in ipairs(currentShift.deliveries) do
        if not d.completed then
            allDone = false
            break
        end
    end

    if allDone then
        ShowNotification3D('Toutes les livraisons terminees! Retourne chercher des commandes.', 'success', 5000)
        currentShift.deliveries = {}
    end
end

-- =============================================================================
-- TRASH COLLECTION (Eboueur)
-- =============================================================================

function DoCollectTrash(jobId, jobData, point, pointIndex)
    local playerPed = PlayerPedId()

    -- Animation
    RequestAnimDict(jobData.animation.dict)
    while not HasAnimDictLoaded(jobData.animation.dict) do
        Wait(100)
    end

    TaskPlayAnim(playerPed, jobData.animation.dict, jobData.animation.anim, 8.0, -8.0, -1, jobData.animation.flag, 0, false, false, false)

    StartProgressBar(point.label, point.time, true)

    local startTime = GetGameTimer()
    while GetGameTimer() - startTime < point.time do
        if IsProgressBarCancelled() then
            StopProgressBar()
            ClearPedTasks(playerPed)
            ShowNotification3D('Action annulee', 'warning', 2000)
            return
        end
        Wait(100)
    end

    StopProgressBar()
    ClearPedTasks(playerPed)

    local bags = math.random(1, 3)
    currentShift.collectedBags = currentShift.collectedBags + bags
    currentShift.tasksCompleted = currentShift.tasksCompleted + 1

    ShowNotification3D('+' .. bags .. ' sac(s) - Total: ' .. currentShift.collectedBags, 'success', 2000)
end

function DepositTrash(jobId, jobData)
    local playerPed = PlayerPedId()

    StartProgressBar('Depot des dechets...', 5000, false)
    Wait(5000)
    StopProgressBar()

    local reward = currentShift.collectedBags * jobData.depositPoint.rewardPerBag
    currentShift.earnings = currentShift.earnings + reward

    TriggerServerEvent('zalco_interim:addMoney', reward)

    ShowNotification3D('Depot termine! +$' .. reward .. ' (' .. currentShift.collectedBags .. ' sacs)', 'success', 4000)

    currentShift.collectedBags = 0
end

-- =============================================================================
-- CLEAN ACTIONS (Agent entretien)
-- =============================================================================

function DoCleanAction(jobId, jobData, point, pointIndex)
    local playerPed = PlayerPedId()

    -- Attacher prop si existe
    if jobData.prop then
        AttachProp(jobData.prop)
    end

    -- Animation
    RequestAnimDict(jobData.animation.dict)
    while not HasAnimDictLoaded(jobData.animation.dict) do
        Wait(100)
    end

    TaskPlayAnim(playerPed, jobData.animation.dict, jobData.animation.anim, 8.0, -8.0, -1, jobData.animation.flag, 0, false, false, false)

    StartProgressBar(point.label, point.time, true)

    local startTime = GetGameTimer()
    while GetGameTimer() - startTime < point.time do
        if IsProgressBarCancelled() then
            StopProgressBar()
            ClearPedTasks(playerPed)
            RemoveProp()
            ShowNotification3D('Action annulee', 'warning', 2000)
            return
        end
        Wait(100)
    end

    StopProgressBar()
    ClearPedTasks(playerPed)
    RemoveProp()

    currentShift.earnings = currentShift.earnings + point.reward
    currentShift.tasksCompleted = currentShift.tasksCompleted + 1

    TriggerServerEvent('zalco_interim:addMoney', point.reward)

    ShowNotification3D(point.label .. ' termine! +$' .. point.reward, 'success', 3000)
end

-- =============================================================================
-- GARDEN ACTIONS (Jardinier)
-- =============================================================================

function DoGardenAction(jobId, jobData, point, pointIndex)
    local playerPed = PlayerPedId()

    -- Attacher prop si existe
    if jobData.prop then
        AttachProp(jobData.prop)
    end

    -- Animation selon le type
    local anim = jobData.animation[point.type] or jobData.animation.tondre

    RequestAnimDict(anim.dict)
    while not HasAnimDictLoaded(anim.dict) do
        Wait(100)
    end

    TaskPlayAnim(playerPed, anim.dict, anim.anim, 8.0, -8.0, -1, anim.flag, 0, false, false, false)

    StartProgressBar(point.label, point.time, true)

    local startTime = GetGameTimer()
    while GetGameTimer() - startTime < point.time do
        if IsProgressBarCancelled() then
            StopProgressBar()
            ClearPedTasks(playerPed)
            RemoveProp()
            ShowNotification3D('Action annulee', 'warning', 2000)
            return
        end
        Wait(100)
    end

    StopProgressBar()
    ClearPedTasks(playerPed)
    RemoveProp()

    currentShift.earnings = currentShift.earnings + point.reward
    currentShift.tasksCompleted = currentShift.tasksCompleted + 1

    TriggerServerEvent('zalco_interim:addMoney', point.reward)

    ShowNotification3D(point.label .. ' termine! +$' .. point.reward, 'success', 3000)
end

-- =============================================================================
-- STATS DISPLAY (3D)
-- =============================================================================

CreateThread(function()
    while true do
        if isWorking and currentJob then
            Wait(0)

            -- Afficher stats en haut a gauche
            local earnings = currentShift.earnings
            local tasks = currentShift.tasksCompleted
            local jobLabel = Config.Jobs[currentJob].label
            local shiftTime = math.floor((GetGameTimer() - currentShift.startTime) / 60000)

            -- Background
            DrawRect(0.09, 0.14, 0.16, 0.09, 20, 20, 30, 200)

            -- Accent bar
            DrawRect(0.01 + 0.003, 0.14, 0.006, 0.09,
                Config.Colors.primary[1], Config.Colors.primary[2], Config.Colors.primary[3], 255)

            -- Title
            SetTextScale(0.35, 0.35)
            SetTextFont(4)
            SetTextColour(Config.Colors.primary[1], Config.Colors.primary[2], Config.Colors.primary[3], 255)
            SetTextEntry("STRING")
            AddTextComponentString('SHIFT: ' .. string.upper(jobLabel))
            DrawText(0.02, 0.105)

            -- Stats
            SetTextScale(0.28, 0.28)
            SetTextFont(4)
            SetTextColour(255, 255, 255, 255)
            SetTextEntry("STRING")
            AddTextComponentString('Gains: $' .. earnings)
            DrawText(0.02, 0.13)

            SetTextScale(0.28, 0.28)
            SetTextFont(4)
            SetTextColour(255, 255, 255, 255)
            SetTextEntry("STRING")
            AddTextComponentString('Taches: ' .. tasks .. ' | Temps: ' .. shiftTime .. 'min')
            DrawText(0.02, 0.155)

            -- Hint
            SetTextScale(0.22, 0.22)
            SetTextFont(4)
            SetTextColour(180, 180, 180, 200)
            SetTextEntry("STRING")
            AddTextComponentString('/stopjob pour terminer')
            DrawText(0.02, 0.175)
        else
            Wait(1000)
        end
    end
end)

-- =============================================================================
-- MISSIONS ILLEGALES SYSTEM
-- =============================================================================

-- Thread pour check si une mission illegale doit pop
CreateThread(function()
    while true do
        if Config.IllegalMissions.enabled and isWorking and currentJob then
            local currentTime = GetGameTimer()

            -- Verifier cooldown
            if currentTime - illegalMission.lastCheck >= Config.IllegalMissions.checkInterval then
                illegalMission.lastCheck = currentTime

                -- Verifier si pas deja en mission et cooldown respecte
                if not illegalMission.active and not illegalMission.pending then
                    if currentTime - illegalMission.lastMissionTime >= Config.IllegalMissions.cooldown then
                        -- Roll pour voir si mission pop
                        local roll = math.random(1, 100)
                        DebugPrint('Mission roll: ' .. roll .. ' (need <= ' .. Config.IllegalMissions.chance .. ')')

                        if roll <= Config.IllegalMissions.chance then
                            TriggerIllegalMission()
                        end
                    end
                end
            end

            Wait(5000)
        else
            Wait(10000)
        end
    end
end)

function TriggerIllegalMission()
    local jobData = Config.Jobs[currentJob]
    if not jobData or not jobData.illegalMissions then return end

    -- Choisir une mission aleatoire
    local missionIndex = math.random(1, #jobData.illegalMissions)
    local mission = jobData.illegalMissions[missionIndex]

    illegalMission.pending = true
    illegalMission.data = mission
    illegalMission.decisionStart = GetGameTimer()

    DebugPrint('Mission illegale proposee: ' .. mission.label)

    -- Notification speciale
    PlaySoundFrontend(-1, "Phone_Generic_Key", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    ShowNotification3D('Un type louche te propose un plan...', 'warning', 6000)
end

-- Thread pour afficher UI de decision mission illegale
CreateThread(function()
    while true do
        if illegalMission.pending and illegalMission.data then
            Wait(0)

            local elapsed = GetGameTimer() - illegalMission.decisionStart
            local remaining = math.max(0, math.floor((Config.IllegalMissions.decisionTime - elapsed) / 1000))

            -- Background panel
            local panelX = 0.5
            local panelY = 0.25
            local panelW = 0.25
            local panelH = 0.12

            DrawRect(panelX, panelY, panelW, panelH, 20, 20, 30, 240)

            -- Accent bar violet (illegal)
            DrawRect(panelX - panelW / 2 + 0.004, panelY, 0.008, panelH,
                Config.Colors.illegal[1], Config.Colors.illegal[2], Config.Colors.illegal[3], 255)

            -- Border
            DrawRect(panelX, panelY - panelH / 2, panelW, 0.003,
                Config.Colors.illegal[1], Config.Colors.illegal[2], Config.Colors.illegal[3], 255)

            -- Title
            SetTextScale(0.4, 0.4)
            SetTextFont(4)
            SetTextColour(Config.Colors.illegal[1], Config.Colors.illegal[2], Config.Colors.illegal[3], 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString('PROPOSITION LOUCHE')
            DrawText(panelX, panelY - 0.05)

            -- Mission label
            SetTextScale(0.32, 0.32)
            SetTextFont(4)
            SetTextColour(255, 255, 255, 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString(illegalMission.data.label)
            DrawText(panelX, panelY - 0.02)

            -- Description
            SetTextScale(0.25, 0.25)
            SetTextFont(4)
            SetTextColour(200, 200, 200, 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString(illegalMission.data.description)
            DrawText(panelX, panelY + 0.005)

            -- Reward
            SetTextScale(0.28, 0.28)
            SetTextFont(4)
            SetTextColour(Config.Colors.success[1], Config.Colors.success[2], Config.Colors.success[3], 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString('Recompense: $' .. illegalMission.data.reward .. ' (argent sale)')
            DrawText(panelX, panelY + 0.03)

            -- Timer + Controls
            SetTextScale(0.25, 0.25)
            SetTextFont(4)
            SetTextColour(255, 255, 255, 200)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString('[Y] Accepter | [N] Refuser | ' .. remaining .. 's')
            DrawText(panelX, panelY + 0.05)

            -- Input handling
            if IsControlJustPressed(0, 246) then -- Y key
                AcceptIllegalMission()
            elseif IsControlJustPressed(0, 249) then -- N key
                RefuseIllegalMission()
            end

            -- Timeout
            if elapsed >= Config.IllegalMissions.decisionTime then
                RefuseIllegalMission()
            end
        else
            Wait(500)
        end
    end
end)

function AcceptIllegalMission()
    if not illegalMission.pending or not illegalMission.data then return end

    local mission = illegalMission.data

    illegalMission.pending = false
    illegalMission.active = true
    illegalMission.startTime = GetGameTimer()

    DebugPrint('Mission acceptee: ' .. mission.label)

    ShowNotification3D('Mission acceptee! ' .. mission.label, 'success', 4000)
    PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

    -- Creer blip si mission avec coords
    if mission.targetCoords then
        local blip = AddBlipForCoord(mission.targetCoords.x, mission.targetCoords.y, mission.targetCoords.z)
        SetBlipSprite(blip, 458)
        SetBlipScale(blip, 0.9)
        SetBlipColour(blip, 27) -- Violet
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 27)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Mission: " .. mission.label)
        EndTextCommandSetBlipName(blip)
        illegalMission.blip = blip
    end

    TriggerServerEvent('zalco_interim:startIllegalMission', currentJob, mission.id)
end

function RefuseIllegalMission()
    if not illegalMission.pending then return end

    illegalMission.pending = false
    illegalMission.data = nil
    illegalMission.lastMissionTime = GetGameTimer()

    DebugPrint('Mission refusee')

    ShowNotification3D('Tu as refuse le plan...', 'info', 3000)
end

function CompleteIllegalMission()
    if not illegalMission.active or not illegalMission.data then return end

    local mission = illegalMission.data

    -- Supprimer blip
    if illegalMission.blip and DoesBlipExist(illegalMission.blip) then
        RemoveBlip(illegalMission.blip)
        illegalMission.blip = nil
    end

    -- Check police alert
    local policeRoll = math.random(1, 100)
    local policeAlert = policeRoll <= Config.IllegalMissions.policeAlertChance

    DebugPrint('Mission complete! Police roll: ' .. policeRoll .. ' (alert if <= ' .. Config.IllegalMissions.policeAlertChance .. ')')

    TriggerServerEvent('zalco_interim:completeIllegalMission', currentJob, mission.id, mission.reward, mission.xpBonus, policeAlert)

    if policeAlert then
        ShowNotification3D('Mission terminee mais les flics ont ete alertes!', 'warning', 5000)
        -- Donner wanted level
        SetPlayerWantedLevel(PlayerId(), 2, false)
        SetPlayerWantedLevelNow(PlayerId(), false)
    else
        ShowNotification3D('Mission terminee! +$' .. mission.reward .. ' (argent sale)', 'success', 5000)
    end

    PlaySoundFrontend(-1, "MEDAL_UP", "HUD_MINI_GAME_SOUNDSET", true)

    currentShift.earnings = currentShift.earnings + mission.reward

    -- Reset
    illegalMission.active = false
    illegalMission.data = nil
    illegalMission.lastMissionTime = GetGameTimer()
end

function FailIllegalMission(reason)
    if not illegalMission.active then return end

    -- Supprimer blip
    if illegalMission.blip and DoesBlipExist(illegalMission.blip) then
        RemoveBlip(illegalMission.blip)
        illegalMission.blip = nil
    end

    ShowNotification3D('Mission echouee: ' .. (reason or 'Temps ecoule'), 'error', 4000)

    TriggerServerEvent('zalco_interim:failIllegalMission', currentJob, illegalMission.data and illegalMission.data.id)

    -- Reset
    illegalMission.active = false
    illegalMission.data = nil
    illegalMission.lastMissionTime = GetGameTimer()
end

-- Thread pour gerer mission illegale active
CreateThread(function()
    while true do
        if illegalMission.active and illegalMission.data then
            Wait(0)

            local mission = illegalMission.data
            local elapsed = GetGameTimer() - illegalMission.startTime
            local remaining = math.max(0, math.floor((mission.time - elapsed) / 1000))

            -- Afficher timer mission
            local timerX = 0.5
            local timerY = 0.08

            DrawRect(timerX, timerY, 0.15, 0.04, 20, 20, 30, 200)
            DrawRect(timerX - 0.075 + 0.003, timerY, 0.006, 0.04,
                Config.Colors.illegal[1], Config.Colors.illegal[2], Config.Colors.illegal[3], 255)

            SetTextScale(0.3, 0.3)
            SetTextFont(4)
            SetTextColour(Config.Colors.illegal[1], Config.Colors.illegal[2], Config.Colors.illegal[3], 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString('MISSION: ' .. remaining .. 's')
            DrawText(timerX + 0.005, timerY - 0.012)

            -- Check timeout
            if elapsed >= mission.time then
                FailIllegalMission('Temps ecoule')
            end

            -- Mission avec items a collecter
            if mission.targetItem and mission.targetAmount then
                local currentAmount = exports.ox_inventory:Search('count', mission.targetItem) or 0

                SetTextScale(0.25, 0.25)
                SetTextFont(4)
                SetTextColour(255, 255, 255, 200)
                SetTextCentre(true)
                SetTextEntry("STRING")
                AddTextComponentString(mission.targetItem .. ': ' .. currentAmount .. '/' .. mission.targetAmount)
                DrawText(timerX + 0.005, timerY + 0.008)

                -- Check si mission complete
                if currentAmount >= mission.targetAmount then
                    CompleteIllegalMission()
                end
            end

            -- Mission avec coords a atteindre
            if mission.targetCoords then
                local playerCoords = GetEntityCoords(PlayerPedId())
                local dist = #(playerCoords - mission.targetCoords)

                if dist < Config.DrawDistance then
                    if dist < Config.InteractDistance then
                        Draw3DTextOnBone(PlayerPedId(), '[E] ' .. mission.label, 0.0, 0.0, 0.6)

                        if not IsProgressBarActive() and IsControlJustPressed(0, 38) then
                            DoIllegalMissionAction(mission)
                        end
                    else
                        Draw3DText(mission.targetCoords + vector3(0, 0, 0.8), mission.label, 0.4, {148, 0, 211}, Config.Colors.white)
                    end
                end
            end
        else
            Wait(500)
        end
    end
end)

function DoIllegalMissionAction(mission)
    local playerPed = PlayerPedId()

    -- Animation
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do
        Wait(100)
    end

    TaskPlayAnim(playerPed, 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 49, 0, false, false, false)

    StartProgressBar(mission.label, 8000, true)

    local startTime = GetGameTimer()
    while GetGameTimer() - startTime < 8000 do
        if IsProgressBarCancelled() then
            StopProgressBar()
            ClearPedTasks(playerPed)
            ShowNotification3D('Action annulee', 'warning', 2000)
            return
        end
        Wait(100)
    end

    StopProgressBar()
    ClearPedTasks(playerPed)

    CompleteIllegalMission()
end

-- Reset mission illegale si on arrete le job
local originalStopJob = StopJob
function StopJob()
    -- Annuler mission illegale si active
    if illegalMission.active then
        FailIllegalMission('Shift termine')
    end
    if illegalMission.pending then
        illegalMission.pending = false
        illegalMission.data = nil
    end

    originalStopJob()
end
