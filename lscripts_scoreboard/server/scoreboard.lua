ESX = exports['es_extended']:getSharedObject()

-- Spieleranzahl & Jobs an Client senden
RegisterNetEvent('scoreboard:requestData', function()
    local xPlayers = ESX.GetPlayers()
    local jobs = { police = 0, ambulance = 0, firefighter = 0 }

    for _, playerId in pairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            local job = xPlayer.job.name
            if job == 'police' then jobs.police = jobs.police + 1
            elseif job == 'ambulance' then jobs.ambulance = jobs.ambulance + 1
            elseif job == 'firefighter' then jobs.firefighter = jobs.firefighter + 1 end
        end
    end

    TriggerClientEvent('scoreboard:update', source, {
        players = #xPlayers,
        jobs = jobs
    })
end)

-- Serverzeit jede Sekunde an Clients senden
CreateThread(function()
    while true do
        Wait(1000)
        local hour = os.date("%H")
        local minute = os.date("%M")
        local timeString = string.format("%02d:%02d", hour, minute)

        for _, playerId in pairs(ESX.GetPlayers()) do
            TriggerClientEvent('scoreboard:updateTime', playerId, timeString)
        end
    end
end)
