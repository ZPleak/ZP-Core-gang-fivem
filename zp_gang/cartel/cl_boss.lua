ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local societycartelmoney = nil
local societyblackcartelmoney = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
    ESX.TriggerServerCallback('cartel:getBlackMoneySociety', function(inventory)
        argent = inventory
    end)
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
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

---------------- FONCTIONS ------------------

function Bosscartel()
  local Bcartel = RageUI.CreateMenu("Actions Patron", "cartel")

    RageUI.Visible(Bcartel, not RageUI.Visible(Bcartel))

            while Bcartel do
                Citizen.Wait(0)
                    RageUI.IsVisible(Bcartel, true, true, true, function()

                    if societycartelmoney ~= nil then
                        RageUI.ButtonWithStyle("Argent société :", nil, {RightLabel = "$" .. societycartelmoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Retirer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = KeyboardInput("Montant", "", 10)
                            amount = tonumber(amount)
                            if amount == nil then
                                RageUI.Popup({message = "Montant invalide"})
                            else
                                TriggerServerEvent('esx_society:withdrawMoney', 'cartel', amount)
                                RefreshcartelMoney()
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Déposer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = KeyboardInput("Montant", "", 10)
                            amount = tonumber(amount)
                            if amount == nil then
                                RageUI.Popup({message = "Montant invalide"})
                            else
                                TriggerServerEvent('esx_society:depositMoney', 'cartel', amount)
                                RefreshcartelMoney()
                            end
                        end
                    end) 

                    RageUI.Separator("↓ Gestion Management ↓")


                    RageUI.ButtonWithStyle("Recruter",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            
                                if closestPlayer == -1 or closestDistance > 3.0 then
                                    ESX.ShowNotification("Aucun Joueur à Proximité")
                                else
                                    TriggerServerEvent('vInventory:Boss_recruterplayer', GetPlayerServerId(closestPlayer), ESX.PlayerData.job2.name, 0)
                                end
                            end
                    end)

                    RageUI.ButtonWithStyle("Promouvoir",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
           
                                if closestPlayer == -1 or closestDistance > 3.0 then
                                    ESX.ShowNotification("Aucun Joueur à Proximité")
                                else
                                    TriggerServerEvent('vInventory:Boss_promouvoirplayer', GetPlayerServerId(closestPlayer))
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Virer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification("Aucun joueur proche")
                            else
                                TriggerServerEvent('vInventory:Boss_virerplayer', GetPlayerServerId(closestPlayer))
                            end
                        end
                    end)

                    RageUI.Separator("↓ Argent Sale ↓")
            

                    if societyblackcartelmoney ~= nil then
                        RageUI.ButtonWithStyle("Argent sale : ", nil, {RightLabel = "$" .. societyblackcartelmoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Déposer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                                local count = KeyboardInput("Combien ?", "", 100)
                                TriggerServerEvent('cartel:putblackmoney', 'item_account', 'black_money', tonumber(count))
                                VDeposerargentsale()
                                ESX.TriggerServerCallback('cartel:getBlackMoneySociety', function(inventory) 
                            end)
                            RefreshblackcartelMoney()
                        end
                    end)

                    RageUI.ButtonWithStyle("Retirer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local count = KeyboardInput("Combien ?", "", 100)
                            ESX.TriggerServerCallback('cartel:getBlackMoneySociety', function(inventory) 
                            TriggerServerEvent('cartel:getItem', 'item_account', 'black_money', tonumber(count))
                            VRetirerargentsale()
                            RefreshblackcartelMoney()
                            end)
                        end
                    end)
                end, function()
            end)
            if not RageUI.Visible(Bcartel) then
            Bcartel = RMenu:DeleteType("Bcartel", true)
        end
    end
end   

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'cartel' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'cartel' and ESX.PlayerData.job2.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, cartel.pos.boss.position.x, cartel.pos.boss.position.y, cartel.pos.boss.position.z)
        if dist3 <= 10.0 and cartel.jeveuxmarker then
            Timer = 0
            DrawMarker(20, cartel.pos.boss.position.x, cartel.pos.boss.position.y, cartel.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 3.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder aux actions patron", time_display = 1 })
                        if IsControlJustPressed(1,51) then           
                            RefreshcartelMoney()
                            RefreshblackcartelMoney()
                            Bosscartel()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshcartelMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietycartelMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function RefreshblackcartelMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('cartel:getBlackMoneySociety', function(inventory)
            UpdateSocietyblackcartelMoney(inventory)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateSocietyblackcartelMoney(inventory)
    societyblackcartelmoney = ESX.Math.GroupDigits(inventory.blackMoney)
end

function UpdateSocietycartelMoney(money)
    societycartelmoney = ESX.Math.GroupDigits(money)
end

function VDeposerargentsale()
    ESX.TriggerServerCallback('cartel:getPlayerInventoryBlack', function(inventory)
        while DepositBlackcartel do
            Citizen.Wait(0)
        end
    end)
end

function VRetirerargentsale()
	ESX.TriggerServerCallback('cartel:getBlackMoneySociety', function(inventory)
	    while StockBlackcartel do
		    Citizen.Wait(0)
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