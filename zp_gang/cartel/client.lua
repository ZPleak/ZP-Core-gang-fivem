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
if cartel.jeveuxblips then
    local cartelmap = AddBlipForCoord(4970.57, -5701.71, 19.89)

    SetBlipSprite(cartelmap, 310)
    SetBlipColour(cartelmap, 52)
    SetBlipScale(cartelmap, 0.80)
    SetBlipAsShortRange(cartelmap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Quartier cartel")
    EndTextCommandSetBlipName(cartelmap)
    end
end)


-- Garage

Gcartelvoiture = {
	{nom = "sanchez", modele = "sanchez"},
	{nom = "Manchez", modele = "manchez"},
	{nom = "deathbike", modele = "deathbike"},
    {nom = "hermes", modele = "hermes"},
    {nom = "winky", modele = "winky"},
    {nom = "seasparrow2", modele = "seasparrow2"},
    {nom = "seasparrow", modele = "seasparrow"},
    {nom = "stafford", modele = "stafford"},
    {nom = "technical", modele = "technical"},
    {nom = "vetir", modele = "vetir"},
}

function Garagecartel()
  local Gcartel = RageUI.CreateMenu("Garage", "cartel")
    RageUI.Visible(Gcartel, not RageUI.Visible(Gcartel))
        while Gcartel do
            Citizen.Wait(0)
                RageUI.IsVisible(Gcartel, true, true, true, function()
                    RageUI.ButtonWithStyle("Ranger la voiture", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then   
                        local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                        if dist4 < 4 then
                            DeleteEntity(veh)
                            end 
                        end
                    end) 

                    for k,v in pairs(Gcartelvoiture) do
                    RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                        Citizen.Wait(1)  
                            spawnuniCarcartel(v.modele)
                            RageUI.CloseAll()
                            end
                        end)
                    end
                end, function()
                end)
            if not RageUI.Visible(Gcartel) then
            Gcartel = RMenu:DeleteType("Gcartel", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cartel' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'cartel' then 
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, cartel.pos.garage.position.x, cartel.pos.garage.position.y, cartel.pos.garage.position.z)
            if dist3 <= 10.0 and cartel.jeveuxmarker then
                Timer = 0
                DrawMarker(20, cartel.pos.garage.position.x, cartel.pos.garage.position.y, cartel.pos.garage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist3 <= 3.0 then
                Timer = 0   
					RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au garage", time_display = 1 })
                    if IsControlJustPressed(1,51) then           
                        Garagecartel()
                    end   
                end
            end 
        Citizen.Wait(Timer)
     end
end)

function spawnuniCarcartel(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, cartel.pos.spawnvoiture.position.x, cartel.pos.spawnvoiture.position.y, cartel.pos.spawnvoiture.position.z, cartel.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "cartel"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
    SetVehicleCustomPrimaryColour(vehicle, 249, 181, 89)
    SetVehicleCustomSecondaryColour(vehicle, 249, 181, 89)
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

function Coffrecartel()
	local Ccartel = RageUI.CreateMenu("Coffre", "cartel")
        RageUI.Visible(Ccartel, not RageUI.Visible(Ccartel))
            while Ccartel do
            Citizen.Wait(0)
            RageUI.IsVisible(Ccartel, true, true, true, function()

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
            if not RageUI.Visible(Ccartel) then
            Ccartel = RMenu:DeleteType("Ccartel", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cartel' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'cartel' then  
            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, cartel.pos.coffre.position.x, cartel.pos.coffre.position.y, cartel.pos.coffre.position.z)
            if jobdist <= 10.0 and cartel.jeveuxmarker then
                Timer = 0
                DrawMarker(20, cartel.pos.coffre.position.x, cartel.pos.coffre.position.y, cartel.pos.coffre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        Coffrecartel()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)

itemstock = {}
function VRetirerobjet()
	local Stockcartel = RageUI.CreateMenu("Coffre", "cartel")
	ESX.TriggerServerCallback('cartel:getStockItems', function(items) 
	itemstock = items
	end)
	RageUI.Visible(Stockcartel, not RageUI.Visible(Stockcartel))
        while Stockcartel do
		    Citizen.Wait(0)
		        RageUI.IsVisible(Stockcartel, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count ~= 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", '' , 8)
                                    TriggerServerEvent('cartel:getStockItem', v.name, tonumber(count))
                                    VRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(Stockcartel) then
            Stockcartel = RMenu:DeleteType("Stockcartel", true)
        end
    end
end

local PlayersItem = {}
function VDeposerobjet()
    local Depositcartel = RageUI.CreateMenu("Coffre", "cartel")
	ESX.TriggerServerCallback('cartel:getPlayerInventory', function(inventory)
        RageUI.Visible(Depositcartel, not RageUI.Visible(Depositcartel))
    while Depositcartel do
        Citizen.Wait(0)
            RageUI.IsVisible(Depositcartel, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('cartel:putStockItems', item.name, tonumber(count))
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
                if not RageUI.Visible(Depositcartel) then
                Depositcartel = RMenu:DeleteType("Coffre", true)
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