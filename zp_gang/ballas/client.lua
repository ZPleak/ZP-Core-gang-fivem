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
if ballas.jeveuxblips then
    local ballasmap = AddBlipForCoord(97.04, -1933.24, 20.8)

    SetBlipSprite(ballasmap, 310)
    SetBlipColour(ballasmap, 27)
    SetBlipScale(ballasmap, 0.80)
    SetBlipAsShortRange(ballasmap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Quartier Ballas")
    EndTextCommandSetBlipName(ballasmap)
end
end)

-- Garage

GBallasvoiture = {
	{nom = "Primo", modele = "primo"},
	{nom = "Manchez", modele = "manchez"},
	{nom = "Van", modele = "moonbeam2"},
    {nom = "Bmx", modele = "bmx"},
    {nom = "Virog", modele = "virgo2"},
    {nom = "Picador", modele = "picador"},
}

function GarageBallas()
  local GBallas = RageUI.CreateMenu("Garage", "Ballas")
    RageUI.Visible(GBallas, not RageUI.Visible(GBallas))
        while GBallas do
            Citizen.Wait(0)
                RageUI.IsVisible(GBallas, true, true, true, function()
                    RageUI.ButtonWithStyle("Ranger la voiture", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then   
                        local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                        if dist4 < 4 then
                            DeleteEntity(veh)
                            end 
                        end
                    end) 

                    for k,v in pairs(GBallasvoiture) do
                    RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                        Citizen.Wait(1)  
                            spawnuniCarBallas(v.modele)
                            RageUI.CloseAll()
                            end
                        end)
                    end
                end, function()
                end)
            if not RageUI.Visible(GBallas) then
            GBallas = RMenu:DeleteType("GBallas", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ballas' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'ballas' then 
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, ballas.pos.garage.position.x, ballas.pos.garage.position.y, ballas.pos.garage.position.z)
            if dist3 <= 10.0 and ballas.jeveuxmarker then
                Timer = 0
                DrawMarker(20, ballas.pos.garage.position.x, ballas.pos.garage.position.y, ballas.pos.garage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 128, 0, 128, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist3 <= 3.0 then
                Timer = 0   
					RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au garage", time_display = 1 })
                    if IsControlJustPressed(1,51) then           
                        GarageBallas()
                    end   
                end
            end 
        Citizen.Wait(Timer)
     end
end)

function spawnuniCarBallas(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, ballas.pos.spawnvoiture.position.x, ballas.pos.spawnvoiture.position.y, ballas.pos.spawnvoiture.position.z, ballas.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "ballas"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
    SetVehicleCustomPrimaryColour(vehicle, 128, 0, 128)
    SetVehicleCustomSecondaryColour(vehicle, 128, 0, 128)
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

function CoffreBallas()
	local CBallas = RageUI.CreateMenu("Coffre", "Ballas")
        RageUI.Visible(CBallas, not RageUI.Visible(CBallas))
            while CBallas do
            Citizen.Wait(0)
            RageUI.IsVisible(CBallas, true, true, true, function()

                RageUI.Separator("↓ Objet / Arme ↓")

                    RageUI.ButtonWithStyle("Retirer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            BRetirerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            BDeposerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                end, function()
                end)
            if not RageUI.Visible(CBallas) then
            CBallas = RMenu:DeleteType("CBallas", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ballas' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'ballas' then  
            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, ballas.pos.coffre.position.x, ballas.pos.coffre.position.y, ballas.pos.coffre.position.z)
            if jobdist <= 10.0 and ballas.jeveuxmarker then
                Timer = 0
                DrawMarker(20, ballas.pos.coffre.position.x, ballas.pos.coffre.position.y, ballas.pos.coffre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 128, 0, 128, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        CoffreBallas()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)

itemstock = {}
function BRetirerobjet()
	local StockBallas = RageUI.CreateMenu("Coffre", "Ballas")
	ESX.TriggerServerCallback('ballas:getStockItems', function(items) 
	itemstock = items
	RageUI.Visible(StockBallas, not RageUI.Visible(StockBallas))
        while StockBallas do
		    Citizen.Wait(0)
		        RageUI.IsVisible(StockBallas, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count ~= 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", '' , 8)
                                    TriggerServerEvent('ballas:getStockItem', v.name, tonumber(count))
                                    BRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(StockBallas) then
            StockBallas = RMenu:DeleteType("Coffre", true)
        end
    end
end)
end

local PlayersItem = {}
function BDeposerobjet()
    local DepositBallas = RageUI.CreateMenu("Coffre", "Ballas")
    ESX.TriggerServerCallback('ballas:getPlayerInventory', function(inventory)
        RageUI.Visible(DepositBallas, not RageUI.Visible(DepositBallas))
    while DepositBallas do
        Citizen.Wait(0)
            RageUI.IsVisible(DepositBallas, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('ballas:putStockItems', item.name, tonumber(count))
                                            BDeposerobjet()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(DepositBallas) then
                DepositBallas = RMenu:DeleteType("Coffre", true)
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