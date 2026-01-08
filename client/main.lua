ESX = exports['es_extended']:getSharedObject()
local currentLab = nil
local isBusy = false
local sellerPeds = {}

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

    -- Blips des vendeurs (si activés)
    for i, seller in pairs(Config.Sellers) do
        if seller.blip.enabled then
            local blip = AddBlipForCoord(seller.coords.x, seller.coords.y, seller.coords.z)
            SetBlipSprite(blip, seller.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, seller.blip.scale)
            SetBlipColour(blip, seller.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(seller.name)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- Spawner les PNJ vendeurs
CreateThread(function()
    for i, seller in pairs(Config.Sellers) do
        RequestModel(GetHashKey(seller.ped))
        while not HasModelLoaded(GetHashKey(seller.ped)) do
            Wait(100)
        end

        local ped = CreatePed(4, GetHashKey(seller.ped), seller.coords.x, seller.coords.y, seller.coords.z - 1.0, seller.heading, false, true)
        SetEntityHeading(ped, seller.heading)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        if seller.scenario then
            TaskStartScenarioInPlace(ped, seller.scenario, 0, true)
        end

        sellerPeds[i] = ped
    end
end)

-- Points de farming
CreateThread(function()
    for i, point in pairs(Config.FarmingPoints) do
        if Config.UseTarget then
            -- Utiliser ox_target
            exports.ox_target:addSphereZone({
                coords = point.coords,
                radius = 1.5,
                options = {
                    {
                        name = 'farm_' .. i,
                        icon = 'fa-solid fa-seedling',
                        label = point.label,
                        onSelect = function()
                            FarmItem(i, point)
                        end,
                        distance = Config.InteractDistance
                    }
                }
            })
        else
            -- Utiliser les markers classiques
            local blip = AddBlipForCoord(point.coords.x, point.coords.y, point.coords.z)
            SetBlipSprite(blip, 1)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.6)
            SetBlipColour(blip, 2)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(point.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

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

-- Vendeurs
CreateThread(function()
    for i, seller in pairs(Config.Sellers) do
        if Config.UseTarget then
            exports.ox_target:addLocalEntity(sellerPeds[i], {
                {
                    name = 'seller_' .. i,
                    icon = 'fa-solid fa-sack-dollar',
                    label = 'Vendre l\'alcool',
                    onSelect = function()
                        SellAlcohol()
                    end,
                    distance = Config.InteractDistance
                }
            })
        end
    end
end)

-- Markers pour les points sans target
if not Config.UseTarget then
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
                    DrawMarker(2, point.coords.x, point.coords.y, point.coords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 46, 204, 113, 200, true, true, 2, false, nil, nil, false)

                    if distance < Config.InteractDistance then
                        ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour ' .. point.label)
                        if IsControlJustReleased(0, 38) then
                            FarmItem(i, point)
                        end
                    end
                end
            end

            -- Labs
            for i, lab in pairs(Config.Labs) do
                local distance = #(playerCoords - lab.coords)
                if distance < Config.DrawDistance then
                    sleep = 0
                    DrawMarker(27, lab.coords.x, lab.coords.y, lab.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 1.0, 220, 20, 60, 200, false, true, 2, false, nil, nil, false)

                    if distance < Config.InteractDistance then
                        ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le laboratoire')
                        if IsControlJustReleased(0, 38) then
                            OpenLabMenu(i)
                        end
                    end
                end
            end

            -- Sellers
            for i, seller in pairs(Config.Sellers) do
                local distance = #(playerCoords - seller.coords)
                if distance < Config.InteractDistance then
                    sleep = 0
                    ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour vendre votre alcool')
                    if IsControlJustReleased(0, 38) then
                        SellAlcohol()
                    end
                end
            end

            Wait(sleep)
        end
    end)
end

-- Fonction de farming
function FarmItem(index, point)
    if isBusy then
        Notify({type = 'error', title = 'Action en cours', message = 'Vous êtes déjà en train de faire quelque chose !', duration = 3000})
        return
    end

    isBusy = true
    local playerPed = PlayerPedId()

    -- Animation
    if point.animation then
        RequestAnimDict(point.animation.dict)
        while not HasAnimDictLoaded(point.animation.dict) do
            Wait(100)
        end
        TaskPlayAnim(playerPed, point.animation.dict, point.animation.anim, 8.0, -8.0, -1, point.animation.flag, 0, false, false, false)
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

-- Vendre l'alcool
function SellAlcohol()
    if isBusy then
        Notify({type = 'error', title = 'Action en cours', message = 'Vous êtes déjà en train de faire quelque chose !', duration = 3000})
        return
    end

    isBusy = true
    local playerPed = PlayerPedId()

    -- Animation
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do
        Wait(100)
    end
    TaskPlayAnim(playerPed, 'mp_common', 'givetake1_a', 8.0, -8.0, -1, 1, 0, false, false, false)

    Wait(2000)
    ClearPedTasks(playerPed)

    TriggerServerEvent('zalco:sellAlcohol')
    isBusy = false
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

if Config.Debug then
    print('^2[ZALCO]^7 Client chargé !')
end
