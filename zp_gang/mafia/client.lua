ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)



Citizen.CreateThread(function()
if mafia.jeveuxblips then
    local mafiamap = AddBlipForCoord(-1527.21, 109.64, 55.64)

    SetBlipSprite(mafiamap, 310)
    SetBlipColour(mafiamap, 0)
    SetBlipScale(mafiamap, 0.80)
    SetBlipAsShortRange(mafiamap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Villa Mafia")
    EndTextCommandSetBlipName(mafiamap)
    end
end)


-- Garage

Gmafiavoiture = {
	{nom = "Oracle", modele = "oracle2"},
	{nom = "4x4", modele = "bjxl"},
    {nom = "Ruffian", modele = "ruffian"},
    {nom = "Buffalo", modele = "buffalo2"},
    {nom = "Btype", modele = "btype3"},
}

function Garagemafia()
  local Gmafia = RageUI.CreateMenu("Garage", "mafia")
    RageUI.Visible(Gmafia, not RageUI.Visible(Gmafia))
        while Gmafia do
            Citizen.Wait(0)
                RageUI.IsVisible(Gmafia, true, true, true, function()
                    RageUI.ButtonWithStyle("Ranger la voiture", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then   
                        local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                        if dist4 < 4 then
                            DeleteEntity(veh)
                            end 
                        end
                    end) 

                    for k,v in pairs(Gmafiavoiture) do
                    RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                        Citizen.Wait(1)  
                            spawnuniCarmafia(v.modele)
                            RageUI.CloseAll()
                            end
                        end)
                    end
                end, function()
                end)
            if not RageUI.Visible(Gmafia) then
            Gmafia = RMenu:DeleteType("Gmafia", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mafia' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'mafia' then 
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, mafia.pos.garage.position.x, mafia.pos.garage.position.y, mafia.pos.garage.position.z)
            if dist3 <= 10.0 and mafia.jeveuxmarker then
                Timer = 0
                DrawMarker(20, mafia.pos.garage.position.x, mafia.pos.garage.position.y, mafia.pos.garage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist3 <= 3.0 then
                Timer = 0   
					RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au garage", time_display = 1 })
                    if IsControlJustPressed(1,51) then           
                        Garagemafia()
                    end   
                end
            end 
        Citizen.Wait(Timer)
     end
end)

function spawnuniCarmafia(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, mafia.pos.spawnvoiture.position.x, mafia.pos.spawnvoiture.position.y, mafia.pos.spawnvoiture.position.z, mafia.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "mafia"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
    SetVehicleCustomPrimaryColour(vehicle, 255, 255, 255)
    SetVehicleCustomSecondaryColour(vehicle, 255, 255, 255)
    SetVehicleMaxMods(vehicle)
end

function SetVehicleMaxMods(vehicle)

    local props = {
      modEngine       = 2,
      modBrakes       = 2,
      modTransmission = 2,
      modSuspension   = 3,
      modTurbo        = true,
    }
  
    ESX.Game.SetVehicleProperties(vehicle, props)
  
  end


-- Coffre

function Coffremafia()
	local Cmafia = RageUI.CreateMenu("Coffre", "mafia")
        RageUI.Visible(Cmafia, not RageUI.Visible(Cmafia))
            while Cmafia do
            Citizen.Wait(0)
            RageUI.IsVisible(Cmafia, true, true, true, function()

                RageUI.Separator("↓ Objet / Arme ↓")

                    RageUI.ButtonWithStyle("Retirer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            VRetirerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            VDeposerobjet()
                            RageUI.CloseAll()
                        end
                    end)

                end, function()
                end)
            if not RageUI.Visible(Cmafia) then
            Cmafia = RMenu:DeleteType("Cmafia", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mafia' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'mafia' then  
            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, mafia.pos.coffre.position.x, mafia.pos.coffre.position.y, mafia.pos.coffre.position.z)
            if jobdist <= 10.0 and mafia.jeveuxmarker then
                Timer = 0
                DrawMarker(20, mafia.pos.coffre.position.x, mafia.pos.coffre.position.y, mafia.pos.coffre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        Coffremafia()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)

itemstock = {}
function VRetirerobjet()
	local Stockmafia = RageUI.CreateMenu("Coffre", "mafia")
	ESX.TriggerServerCallback('mafia:getStockItems', function(items) 
	itemstock = items
	end)
	RageUI.Visible(Stockmafia, not RageUI.Visible(Stockmafia))
        while Stockmafia do
		    Citizen.Wait(0)
		        RageUI.IsVisible(Stockmafia, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count ~= 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", '' , 8)
                                    TriggerServerEvent('mafia:getStockItem', v.name, tonumber(count))
                                    VRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(Stockmafia) then
            Stockmafia = RMenu:DeleteType("Stockmafia", true)
        end
    end
end

local PlayersItem = {}
function VDeposerobjet()
    local Depositmafia = RageUI.CreateMenu("Coffre", "mafia")
	ESX.TriggerServerCallback('mafia:getPlayerInventory', function(inventory)
        RageUI.Visible(Depositmafia, not RageUI.Visible(Depositmafia))
    while Depositmafia do
        Citizen.Wait(0)
            RageUI.IsVisible(Depositmafia, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('mafia:putStockItems', item.name, tonumber(count))
                                            VDeposerobjet()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(Depositmafia) then
                Depositmafia = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end