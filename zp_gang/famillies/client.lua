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
if famillies.jeveuxblips then
    local familliesmap = AddBlipForCoord(-140.27, -1597.62, 34.83)

    SetBlipSprite(familliesmap, 310)
    SetBlipColour(familliesmap, 25)
    SetBlipScale(familliesmap, 0.80)
    SetBlipAsShortRange(familliesmap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Quartier Famillies")
    EndTextCommandSetBlipName(familliesmap)
end
end)

-- Garage

GFamilliesvoiture = {
	{nom = "Primo", modele = "primo"},
	{nom = "Manchez", modele = "manchez"},
	{nom = "Van", modele = "moonbeam2"},
    {nom = "Bmx", modele = "bmx"},
    {nom = "Virog", modele = "virgo2"},
    {nom = "Picador", modele = "picador"},
}

function GarageFamillies()
  local GFamillies = RageUI.CreateMenu("Garage", "Famillies")
    RageUI.Visible(GFamillies, not RageUI.Visible(GFamillies))
        while GFamillies do
            Citizen.Wait(0)
                RageUI.IsVisible(GFamillies, true, true, true, function()
                    RageUI.ButtonWithStyle("Ranger la voiture", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then   
                        local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                        if dist4 < 4 then
                            DeleteEntity(veh)
                            end 
                        end
                    end) 

                    for k,v in pairs(GFamilliesvoiture) do
                    RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                        Citizen.Wait(1)  
                            spawnuniCarFamillies(v.modele)
                            RageUI.CloseAll()
                            end
                        end)
                    end
                end, function()
                end)
            if not RageUI.Visible(GFamillies) then
            GFamillies = RMenu:DeleteType("GFamillies", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'famillies' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'famillies' then 
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, famillies.pos.garage.position.x, famillies.pos.garage.position.y, famillies.pos.garage.position.z)
            if dist3 <= 10.0 and famillies.jeveuxmarker then
                Timer = 0
                DrawMarker(20, famillies.pos.garage.position.x, famillies.pos.garage.position.y, famillies.pos.garage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 34, 139, 34, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist3 <= 3.0 then
                Timer = 0   
					RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au garage", time_display = 1 })
                    if IsControlJustPressed(1,51) then           
                        GarageFamillies()
                    end   
                end
            end 
        Citizen.Wait(Timer)
     end
end)

function spawnuniCarFamillies(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, famillies.pos.spawnvoiture.position.x, famillies.pos.spawnvoiture.position.y, famillies.pos.spawnvoiture.position.z, famillies.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "famillies"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
    SetVehicleCustomPrimaryColour(vehicle, 34, 139, 34)
    SetVehicleCustomSecondaryColour(vehicle, 34, 139, 34)
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

function CoffreFamillies()
	local CFamillies = RageUI.CreateMenu("Coffre", "Famillies")
        RageUI.Visible(CFamillies, not RageUI.Visible(CFamillies))
            while CFamillies do
            Citizen.Wait(0)
            RageUI.IsVisible(CFamillies, true, true, true, function()

                RageUI.Separator("↓ Objet / Arme ↓")

                    RageUI.ButtonWithStyle("Retirer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            FRetirerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            FDeposerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                end, function()
                end)
            if not RageUI.Visible(CFamillies) then
            CFamillies = RMenu:DeleteType("CFamillies", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'famillies' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'famillies' then  
            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, famillies.pos.coffre.position.x, famillies.pos.coffre.position.y, famillies.pos.coffre.position.z)
            if jobdist <= 10.0 and famillies.jeveuxmarker then
                Timer = 0
                DrawMarker(20, famillies.pos.coffre.position.x, famillies.pos.coffre.position.y, famillies.pos.coffre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 34, 139, 34, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder au coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        CoffreFamillies()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)

itemstock = {}
function FRetirerobjet()
	local StockFamillies = RageUI.CreateMenu("Coffre", "Famillies")
	ESX.TriggerServerCallback('famillies:getStockItems', function(items) 
	itemstock = items
	end)
	RageUI.Visible(StockFamillies, not RageUI.Visible(StockFamillies))
        while StockFamillies do
		    Citizen.Wait(0)
		        RageUI.IsVisible(StockFamillies, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count ~= 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", '' , 8)
                                    TriggerServerEvent('famillies:getStockItem', v.name, tonumber(count))
                                    FRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(StockFamillies) then
            StockFamillies = RMenu:DeleteType("Coffre", true)
        end
    end
end

local PlayersItem = {}
function FDeposerobjet()
    local DepositFamillies = RageUI.CreateMenu("Coffre", "Famillies")
	ESX.TriggerServerCallback('famillies:getPlayerInventory', function(inventory)
        RageUI.Visible(StockFamillies, not RageUI.Visible(StockFamillies))
    while DepositFamillies do
        Citizen.Wait(0)
            RageUI.IsVisible(DepositFamillies, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('famillies:putStockItems', item.name, tonumber(count))
                                            FDeposerobjet()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(DepositFamillies) then
                DepositFamillies = RMenu:DeleteType("Coffre", true)
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