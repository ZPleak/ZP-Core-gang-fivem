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
if marabunta.jeveuxblips then
    local maramap = AddBlipForCoord(1436.87, -1494.1, 63.22)

    SetBlipSprite(maramap, 310)
    SetBlipColour(maramap, 38)
    SetBlipScale(maramap, 0.80)
    SetBlipAsShortRange(maramap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Quartier Marabunta")
    EndTextCommandSetBlipName(maramap)
end
end)


-- Garage

GMarabuntavoiture = {
	{nom = "Primo", modele = "primo"},
	{nom = "Manchez", modele = "manchez"},
	{nom = "Van", modele = "moonbeam2"},
    {nom = "Bmx", modele = "bmx"},
    {nom = "Virog", modele = "virgo2"},
    {nom = "Picador", modele = "picador"},
}

function GarageMarabunta()
  local GMarabunta = RageUI.CreateMenu("Garage", "Marabunta")
    RageUI.Visible(GMarabunta, not RageUI.Visible(GMarabunta))
        while GMarabunta do
            Citizen.Wait(0)
                RageUI.IsVisible(GMarabunta, true, true, true, function()
                    RageUI.ButtonWithStyle("Ranger la voiture", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then   
                        local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                        if dist4 < 4 then
                            DeleteEntity(veh)
                            end 
                        end
                    end) 

                    for k,v in pairs(GMarabuntavoiture) do
                    RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                        Citizen.Wait(1)  
                            spawnuniCarMarabunta(v.modele)
                            RageUI.CloseAll()
                            end
                        end)
                    end
                end, function()
                end)
            if not RageUI.Visible(GMarabunta) then
            GMarabunta = RMenu:DeleteType("GMarabunta", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'marabunta' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'marabunta' then 
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, marabunta.pos.garage.position.x, marabunta.pos.garage.position.y, marabunta.pos.garage.position.z)
            if dist3 <= 10.0 and marabunta.jeveuxmarker then
                Timer = 0
                DrawMarker(20, marabunta.pos.garage.position.x, marabunta.pos.garage.position.y, marabunta.pos.garage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 65, 105, 225, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist3 <= 3.0 then
                Timer = 0   
					RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au garage", time_display = 1 })
                    if IsControlJustPressed(1,51) then           
                        GarageMarabunta()
                    end   
                end
            end 
        Citizen.Wait(Timer)
     end
end)

function spawnuniCarMarabunta(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, marabunta.pos.spawnvoiture.position.x, marabunta.pos.spawnvoiture.position.y, marabunta.pos.spawnvoiture.position.z, marabunta.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "marabunta"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
    SetVehicleCustomPrimaryColour(vehicle, 65, 105, 225)
    SetVehicleCustomSecondaryColour(vehicle, 65, 105, 225)
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

function CoffreMarabunta()
	local CMarabunta = RageUI.CreateMenu("Coffre", "Marabunta")
        RageUI.Visible(CMarabunta, not RageUI.Visible(CMarabunta))
            while CMarabunta do
            Citizen.Wait(0)
            RageUI.IsVisible(CMarabunta, true, true, true, function()

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
            if not RageUI.Visible(CMarabunta) then
            CMarabunta = RMenu:DeleteType("CMarabunta", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'marabunta' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'marabunta' then  
            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, marabunta.pos.coffre.position.x, marabunta.pos.coffre.position.y, marabunta.pos.coffre.position.z)
            if jobdist <= 10.0 and marabunta.jeveuxmarker then
                Timer = 0
                DrawMarker(20, marabunta.pos.coffre.position.x, marabunta.pos.coffre.position.y, marabunta.pos.coffre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 65, 105, 225, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        CoffreMarabunta()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)

itemstock = {}
function MRetirerobjet()
	local StockMarabunta = RageUI.CreateMenu("Coffre", "Marabunta")
	ESX.TriggerServerCallback('marabunta:getStockItems', function(items) 
	itemstock = items
	end)
	RageUI.Visible(StockMarabunta, not RageUI.Visible(StockMarabunta))
        while StockMarabunta do
		    Citizen.Wait(0)
		        RageUI.IsVisible(StockMarabunta, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count ~= 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", '' , 8)
                                    TriggerServerEvent('marabunta:getStockItem', v.name, tonumber(count))
                                    MRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(StockMarabunta) then
            StockMarabunta = RMenu:DeleteType("StockMarabunta", true)
        end
    end
end

local PlayersItem = {}
function MDeposerobjet()
    local DepositMarabunta = RageUI.CreateMenu("Coffre", "Marabunta")
	ESX.TriggerServerCallback('marabunta:getPlayerInventory', function(inventory)
        RageUI.Visible(DepositMarabunta, not RageUI.Visible(DepositMarabunta))
    while DepositMarabunta do
        Citizen.Wait(0)
            RageUI.IsVisible(DepositMarabunta, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('marabunta:putStockItems', item.name, tonumber(count))
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
                if not RageUI.Visible(DepositMarabunta) then
                DepositMarabunta = RMenu:DeleteType("Coffre", true)
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