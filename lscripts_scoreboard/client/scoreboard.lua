ESX = nil
local scoreboardVisible = false
local playersOnline = 0
local serverTime = '00:00'
local playerId = GetPlayerServerId(PlayerId())
local playerJob = { name = '', label = '', grade_label = '' }
local jobsCount = { police = 0, ambulance = 0, firefighter = 0, mechanice = 0, cardealer = 0, broker = 0, electrician = 0 }

-- Funktion für NUI Update
local function updateNUI()
    SendNUIMessage({
        action = 'update',
        id = playerId,
        time = serverTime,
        job_label = playerJob.label,
        job_grade = playerJob.grade_label,
        players = playersOnline,
        jobsCount = jobsCount
    })
end

-- Warten, bis ESX verfügbar ist
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end

    -- Warten bis PlayerLoaded
    while ESX.GetPlayerData().job == nil do
        Wait(100)
    end

    local job = ESX.GetPlayerData().job
    playerJob = { name = job.name, label = job.label, grade_label = job.grade_label }
    updateNUI()
end)

-- Job-Änderung dynamisch
RegisterNetEvent('esx:setJob', function(job)
    if job then
        playerJob = { name = job.name, label = job.label, grade_label = job.grade_label }
        updateNUI()
    end
end)

-- Scoreboard Toggle
RegisterCommand('scoreboard', function()
    scoreboardVisible = not scoreboardVisible
    SendNUIMessage({ action = 'toggle', show = scoreboardVisible })
end)

-- TAB Toggle
CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, 37) then
            scoreboardVisible = true
            SendNUIMessage({ action = 'toggle', show = true })
        elseif IsControlJustReleased(0, 37) then
            scoreboardVisible = false
            SendNUIMessage({ action = 'toggle', show = false })
        end
    end
end)

-- Daten vom Server abrufen
CreateThread(function()
    while true do
        Wait(1000)
        TriggerServerEvent('scoreboard:requestData')
    end
end)

-- Event: Spieleranzahl & Jobs
RegisterNetEvent('scoreboard:update', function(data)
    playersOnline = data.players
    jobsCount = data.jobs
    updateNUI()
end)

-- Event: Serverzeit
RegisterNetEvent('scoreboard:updateTime', function(time)
    serverTime = time
    updateNUI()
end)
