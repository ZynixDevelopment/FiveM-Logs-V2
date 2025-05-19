-- CONFIGURATION
local webhook = "TON_WEBHOOK_DISCORD_ICI"

-- UTILITIES
function getPlayerIdentifiersList(src)
    local id = {
        steam = "N/A",
        license = "N/A",
        discord = "N/A",
        ip = "N/A"
    }
    for _, v in ipairs(GetPlayerIdentifiers(src)) do
        if v:find("steam:") then id.steam = v end
        if v:find("license:") then id.license = v end
        if v:find("discord:") then id.discord = "<@"..tonumber(v:gsub("discord:", ""))..">" end
        if v:find("ip:") then id.ip = v:gsub("ip:", "") end
    end
    return id
end

function sendToDiscord(title, message, color)
    local embed = {
        {
            ["title"] = title,
            ["description"] = message,
            ["color"] = color or 16777215, -- white by default
            ["footer"] = { ["text"] = "FiveM Logger by ZynixDevelopment" },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "FiveM LOGS",
        avatar_url = "https://i.imgur.com/4M34hi2.png",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

-- FRAMEWORK DETECTION
local ESX, QBCore = nil, nil
CreateThread(function()
    if GetResourceState('es_extended') == 'started' then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    elseif GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
end)

-- LOGS DE CONNEXION
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local ids = getPlayerIdentifiersList(source)
    local msg = ("**Joueur:** `%s`\n**Steam:** `%s`\n**License:** `%s`\n**Discord:** %s\n**IP:** `%s`\n**Source:** `%s`"):format(
        name, ids.steam, ids.license, ids.discord, ids.ip, source
    )
    sendToDiscord("🟢 Connexion", msg, 5763719)
end)

AddEventHandler('playerDropped', function(reason)
    local name = GetPlayerName(source)
    local ids = getPlayerIdentifiersList(source)
    local msg = ("**Joueur:** `%s`\n**Raison:** `%s`\n**Steam:** `%s`\n**License:** `%s`\n**Discord:** %s\n**IP:** `%s`\n**Source:** `%s`"):format(
        name or "Inconnu", reason or "Aucune", ids.steam, ids.license, ids.discord, ids.ip, source
    )
    sendToDiscord("🔴 Déconnexion", msg, 15548997)
end)

-- LOGS CHAT & COMMANDES
RegisterServerEvent('chatMessage')
AddEventHandler('chatMessage', function(source, name, msg)
    if msg:sub(1, 1) == "/" then
        sendToDiscord("⚙️ Commande", ("**[%s]** `%s`"):format(name, msg), 3447003)
    else
        sendToDiscord("💬 Chat", ("**[%s]** %s"):format(name, msg), 15844367)
    end
end)

-- LOGS ADMIN (BAN/KICK/WARN) - EXEMPLE ESX/QBCore
RegisterServerEvent('admin:ban')
AddEventHandler('admin:ban', function(target, reason)
    local srcName = GetPlayerName(source)
    local tgtName = GetPlayerName(target)
    local ids = getPlayerIdentifiersList(target)
    sendToDiscord("⛔ BAN", ("**Admin:** `%s`\n**Joueur:** `%s`\n**Raison:** `%s`\n%s"):format(srcName, tgtName, reason, ids.license), 13632027)
end)

RegisterServerEvent('admin:kick')
AddEventHandler('admin:kick', function(target, reason)
    local srcName = GetPlayerName(source)
    local tgtName = GetPlayerName(target)
    local ids = getPlayerIdentifiersList(target)
    sendToDiscord("🚫 KICK", ("**Admin:** `%s`\n**Joueur:** `%s`\n**Raison:** `%s`\n%s"):format(srcName, tgtName, reason, ids.license), 15158332)
end)

RegisterServerEvent('admin:warn')
AddEventHandler('admin:warn', function(target, reason)
    local srcName = GetPlayerName(source)
    local tgtName = GetPlayerName(target)
    local ids = getPlayerIdentifiersList(target)
    sendToDiscord("⚠️ WARN", ("**Admin:** `%s`\n**Joueur:** `%s`\n**Raison:** `%s`\n%s"):format(srcName, tgtName, reason, ids.license), 15105570)
end)

-- LOGS GIVE ARGENT/ITEMS/VEHICULES (ESX/QBCore)
RegisterServerEvent('admin:giveMoney')
AddEventHandler('admin:giveMoney', function(target, amount, type)
    local srcName = GetPlayerName(source)
    local tgtName = GetPlayerName(target)
    sendToDiscord("💸 Give Argent", ("**Admin:** `%s`\n**Joueur:** `%s`\n**Montant:** `%s`\n**Type:** `%s`"):format(srcName, tgtName, amount, type), 3066993)
end)
RegisterServerEvent('admin:giveItem')
AddEventHandler('admin:giveItem', function(target, item, qty)
    local srcName = GetPlayerName(source)
    local tgtName = GetPlayerName(target)
    sendToDiscord("📦 Give Item", ("**Admin:** `%s`\n**Joueur:** `%s`\n**Item:** `%s`\n**Quantité:** `%s`"):format(srcName, tgtName, item, qty), 10181046)
end)
RegisterServerEvent('admin:giveVehicle')
AddEventHandler('admin:giveVehicle', function(target, model)
    local srcName = GetPlayerName(source)
    local tgtName = GetPlayerName(target)
    sendToDiscord("🚗 Give Véhicule", ("**Admin:** `%s`\n**Joueur:** `%s`\n**Modèle:** `%s`"):format(srcName, tgtName, model), 15105570)
end)

-- LOGS ARGENT/INVENTAIRE/JOB (ESX/QBCore auto)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, lastJob)
    local xPlayer = ESX.GetPlayerFromId(source)
    sendToDiscord("💼 Job (ESX)", ("**%s**\n`%s` ➔ `%s`"):format(xPlayer.getName(), lastJob.name, job.name), 15844367)
end)
RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account, money)
    local xPlayer = ESX.GetPlayerFromId(source)
    sendToDiscord("💸 Argent (ESX)", ("**%s (%s)**\nCompte `%s` : `%s`"):format(xPlayer.getName(), xPlayer.getIdentifier(), account, money), 3066993)
end)
RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    sendToDiscord("📦 Ajout Item (ESX)", ("**%s (%s)**\n+`%s` %s"):format(xPlayer.getName(), xPlayer.getIdentifier(), count, item), 10181046)
end)
RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    sendToDiscord("📦 Retrait Item (ESX)", ("**%s (%s)**\n-`%s` %s"):format(xPlayer.getName(), xPlayer.getIdentifier(), count, item), 15158332)
end)
RegisterNetEvent('esx_vehicleshop:setVehicleOwnedPlayerId')
AddEventHandler('esx_vehicleshop:setVehicleOwnedPlayerId', function(playerId, plate, props, type)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    sendToDiscord("🚙 Achat Véhicule (ESX)", ("**%s (%s)**\nPlage: `%s`"):format(xPlayer.getName(), xPlayer.getIdentifier(), plate), 3447003)
end)

-- QBCore équivalents (ajoutez/activez si QBCore détecté)
RegisterNetEvent('QBCore:Server:OnJobUpdate')
AddEventHandler('QBCore:Server:OnJobUpdate', function(job, lastJob)
    local Player = QBCore.Functions.GetPlayer(source)
    sendToDiscord("💼 Job (QBCore)", ("**%s (%s)**\n`%s` ➔ `%s`"):format(Player.PlayerData.name, Player.PlayerData.citizenid, lastJob.name, job.name), 15844367)
end)
RegisterNetEvent('QBCore:Player:SetPlayerData')
AddEventHandler('QBCore:Player:SetPlayerData', function(data)
    if data.money then
        sendToDiscord("💸 Argent (QBCore)", ("**%s (%s)**\n%s"):format(data.name, data.citizenid, json.encode(data.money)), 3066993)
    end
end)
RegisterNetEvent('QBCore:Player:AddItem')
AddEventHandler('QBCore:Player:AddItem', function(item, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    sendToDiscord("📦 Ajout Item (QBCore)", ("**%s (%s)**\n+`%s` %s"):format(Player.PlayerData.name, Player.PlayerData.citizenid, amount, item), 10181046)
end)
RegisterNetEvent('QBCore:Player:RemoveItem')
AddEventHandler('QBCore:Player:RemoveItem', function(item, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    sendToDiscord("📦 Retrait Item (QBCore)", ("**%s (%s)**\n-`%s` %s"):format(Player.PlayerData.name, Player.PlayerData.citizenid, amount, item), 15158332)
end)

-- LOGS DES RESSOURCES
AddEventHandler('onResourceStart', function(resourceName)
    sendToDiscord("🟢 Ressource Démarrée", ("`%s`"):format(resourceName), 5763719)
end)
AddEventHandler('onResourceStop', function(resourceName)
    sendToDiscord("🔴 Ressource Arrêtée", ("`%s`"):format(resourceName), 15548997)
end)

-- LOGS DE CRASHS
AddEventHandler('onPlayerDied', function(reason)
    local name = GetPlayerName(source)
    sendToDiscord("💀 Crash/Mort", ("**%s**\n%s"):format(name, reason or "Inconnu"), 10038562)
end)

-- LOGS PERFORMANCE
CreateThread(function()
    while true do
        Wait(60000) -- Toutes les minutes
        for _, playerId in ipairs(GetPlayers()) do
            local ping = GetPlayerPing(playerId)
            if ping and ping > 180 then
                local name = GetPlayerName(playerId)
                sendToDiscord("🏓 Ping élevé", ("**%s**\nPing: `%sms`"):format(name, ping), 15844367)
            end
        end
    end
end)

-- LOGS ANTI-CHEAT/EXPLOIT
RegisterServerEvent('exploit:detected')
AddEventHandler('exploit:detected', function(data)
    local name = GetPlayerName(source)
    sendToDiscord("🚨 Exploit détecté", ("**%s**\n%s"):format(name, json.encode(data)), 13632027)
end)

-- LOG TEST
RegisterCommand("logtest", function(source)
    sendToDiscord("✅ Test Log", ("Par: %s"):format(GetPlayerName(source)), 5763719)
end, false)
