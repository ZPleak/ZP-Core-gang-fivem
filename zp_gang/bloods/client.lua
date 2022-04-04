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
if bloods.jeveuxblips then
    local maramap = AddBlipForCoord(-1556.8, -375.97, 48.05)

    SetBlipSprite(maramap, 310)
    SetBlipColour(maramap, 1)
    SetBlipScale(maramap, 0.80)
    SetBlipAsShortRange(maramap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Quartier bloods")
    EndTextCommandSetBlipName(maramap)
end
end)


-- Garage

Gbloodsvoiture = {
	{nom = "Glendale", modele = "glendale"},
	{nom = "Kamacho", modele = "kamacho"},
    {nom = "Jackal", modele = "jackal"},
}

function Garagebloods()
  local Gbloods = RageUI.CreateMenu("Garage", "bloods Diaz")
    RageUI.Visible(Gbloods, not RageUI.Visible(Gbloods))
        while Gbloods do
            Citizen.Wait(0)
                RageUI.IsVisible(Gbloods, true, true, true, function()
                    RageUI.ButtonWithStyle("Ranger la voiture", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then   
                        local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                        if dist4 < 4 then
                            DeleteEntity(veh)
                            end 
                        end
                    end) 

                    for k,v in pairs(Gbloodsvoiture) do
                    RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                        Citizen.Wait(1)  
                            spawnuniCarbloods(v.modele)
                            RageUI.CloseAll()
                            end
                        end)
                    end
                end, function()
                end)
            if not RageUI.Visible(Gbloods) then
            Gbloods = RMenu:DeleteType("Gbloods", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bloods' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'bloods' then 
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, bloods.pos.garage.position.x, bloods.pos.garage.position.y, bloods.pos.garage.position.z)
            if dist3 <= 10.0 and bloods.jeveuxmarker then
                Timer = 0
                DrawMarker(20, bloods.pos.garage.position.x, bloods.pos.garage.position.y, bloods.pos.garage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 60, 0, 255, 0, 0, nil, nil, 0)
                end
                if dist3 <= 3.0 then
                Timer = 0   
					RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au garage", time_display = 1 })
                    if IsControlJustPressed(1,51) then           
                        Garagebloods()
                    end   
                end
            end 
        Citizen.Wait(Timer)
     end
end)

function spawnuniCarbloods(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, bloods.pos.spawnvoiture.position.x, bloods.pos.spawnvoiture.position.y, bloods.pos.spawnvoiture.position.z, bloods.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "bloods"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
    SetVehicleCustomPrimaryColour(vehicle, 231, 23, 23)
    SetVehicleCustomSecondaryColour(vehicle, 231, 23, 23)
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

function Coffrebloods()
	local Cbloods = RageUI.CreateMenu("Coffre", "bloods Diaz")
        RageUI.Visible(Cbloods, not RageUI.Visible(Cbloods))
            while Cbloods do
            Citizen.Wait(0)
            RageUI.IsVisible(Cbloods, true, true, true, function()

                RageUI.Separator("↓ Objet / Arme ↓")

                    RageUI.ButtonWithStyle("Retirer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            MRetirerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            MDeposerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                end, function()
                end)
            if not RageUI.Visible(Cbloods) then
            Cbloods = RMenu:DeleteType("Cbloods", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bloods' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'bloods' then  
            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, bloods.pos.coffre.position.x, bloods.pos.coffre.position.y, bloods.pos.coffre.position.z)
            if jobdist <= 10.0 and bloods.jeveuxmarker then
                Timer = 0
                DrawMarker(20, bloods.pos.coffre.position.x, bloods.pos.coffre.position.y, bloods.pos.coffre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 60, 0, 255, 0, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        Coffrebloods()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)

itemstock = {}
function MRetirerobjet()
	local Stockbloods = RageUI.CreateMenu("Coffre", "bloods Diaz")
	ESX.TriggerServerCallback('bloods:getStockItems', function(items) 
	itemstock = items
	end)
	RageUI.Visible(Stockbloods, not RageUI.Visible(Stockbloods))
        while Stockbloods do
		    Citizen.Wait(0)
		        RageUI.IsVisible(Stockbloods, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count ~= 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", '' , 8)
                                    TriggerServerEvent('bloods:getStockItem', v.name, tonumber(count))
                                    MRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(Stockbloods) then
            Stockbloods = RMenu:DeleteType("Stockbloods", true)
        end
    end
end

local PlayersItem = {}
function MDeposerobjet()
    local Depositbloods = RageUI.CreateMenu("Coffre", "bloods Diaz")
	ESX.TriggerServerCallback('bloods:getPlayerInventory', function(inventory)
        RageUI.Visible(Depositbloods, not RageUI.Visible(Depositbloods))
    while Depositbloods do
        Citizen.Wait(0)
            RageUI.IsVisible(Depositbloods, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('bloods:putStockItems', item.name, tonumber(count))
                                            MDeposerobjet()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(Depositbloods) then
                Depositbloods = RMenu:DeleteType("Coffre", true)
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