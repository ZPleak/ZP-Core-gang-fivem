ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local societymafiamoney = nil
local societyblackmafiamoney = nil

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
    ESX.TriggerServerCallback('mafia:getBlackMoneySociety', function(inventory)
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

function Bossmafia()
  local Bmafia = RageUI.CreateMenu("Actions Patron", "mafia")

    RageUI.Visible(Bmafia, not RageUI.Visible(Bmafia))

            while Bmafia do
                Citizen.Wait(0)
                    RageUI.IsVisible(Bmafia, true, true, true, function()

                    if societymafiamoney ~= nil then
                        RageUI.ButtonWithStyle("Argent société :", nil, {RightLabel = "$" .. societymafiamoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Retirer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = KeyboardInput("Montant", "", 10)
                            amount = tonumber(amount)
                            if amount == nil then
                                RageUI.Popup({message = "Montant invalide"})
                            else
                                TriggerServerEvent('esx_society:withdrawMoney', 'mafia', amount)
                                RefreshmafiaMoney()
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
                                TriggerServerEvent('esx_society:depositMoney', 'mafia', amount)
                                RefreshmafiaMoney()
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
            

                    if societyblackmafiamoney ~= nil then
                        RageUI.ButtonWithStyle("Argent sale : ", nil, {RightLabel = "$" .. societyblackmafiamoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Déposer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                                local count = KeyboardInput("Combien ?", "", 100)
                                TriggerServerEvent('mafia:putblackmoney', 'item_account', 'black_money', tonumber(count))
                                VDeposerargentsale()
                                ESX.TriggerServerCallback('mafia:getBlackMoneySociety', function(inventory) 
                            end)
                            RefreshblackmafiaMoney()
                        end
                    end)

                    RageUI.ButtonWithStyle("Retirer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local count = KeyboardInput("Combien ?", "", 100)
                            ESX.TriggerServerCallback('mafia:getBlackMoneySociety', function(inventory) 
                            TriggerServerEvent('mafia:getItem', 'item_account', 'black_money', tonumber(count))
                            VRetirerargentsale()
                            RefreshblackmafiaMoney()
                            end)
                        end
                    end)
                end, function()
            end)
            if not RageUI.Visible(Bmafia) then
            Bmafia = RMenu:DeleteType("Bmafia", true)
        end
    end
end   

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mafia' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'mafia' and ESX.PlayerData.job2.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, mafia.pos.boss.position.x, mafia.pos.boss.position.y, mafia.pos.boss.position.z)
        if dist3 <= 10.0 and mafia.jeveuxmarker then
            Timer = 0
            DrawMarker(20, mafia.pos.boss.position.x, mafia.pos.boss.position.y, mafia.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 3.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder aux actions patron", time_display = 1 })
                        if IsControlJustPressed(1,51) then           
                            RefreshmafiaMoney()
                            RefreshblackmafiaMoney()
                            Bossmafia()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshmafiaMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietymafiaMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function RefreshblackmafiaMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('mafia:getBlackMoneySociety', function(inventory)
            UpdateSocietyblackmafiaMoney(inventory)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateSocietyblackmafiaMoney(inventory)
    societyblackmafiamoney = ESX.Math.GroupDigits(inventory.blackMoney)
end

function UpdateSocietymafiaMoney(money)
    societymafiamoney = ESX.Math.GroupDigits(money)
end

function VDeposerargentsale()
    ESX.TriggerServerCallback('mafia:getPlayerInventoryBlack', function(inventory)
        while DepositBlackmafia do
            Citizen.Wait(0)
        end
    end)
end

function VRetirerargentsale()
	ESX.TriggerServerCallback('mafia:getBlackMoneySociety', function(inventory)
	    while StockBlackmafia do
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