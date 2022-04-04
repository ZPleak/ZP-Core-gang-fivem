ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local societymarabuntamoney = nil
local societyblackmarabuntamoney = nil

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
    ESX.TriggerServerCallback('marabunta:getBlackMoneySociety', function(inventory)
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

function BossMarabunta()
  local BMarabunta = RageUI.CreateMenu("Actions Patron", "Marabunta")

    RageUI.Visible(BMarabunta, not RageUI.Visible(BMarabunta))

            while BMarabunta do
                Citizen.Wait(0)
                    RageUI.IsVisible(BMarabunta, true, true, true, function()

                    if societymarabuntamoney ~= nil then
                        RageUI.ButtonWithStyle("Argent société :", nil, {RightLabel = "$" .. societymarabuntamoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Retirer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = KeyboardInput("Montant", "", 10)
                            amount = tonumber(amount)
                            if amount == nil then
                                RageUI.Popup({message = "Montant invalide"})
                            else
                                TriggerServerEvent('esx_society:withdrawMoney', 'marabunta', amount)
                                RefreshmarabuntaMoney()
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
                                TriggerServerEvent('esx_society:depositMoney', 'marabunta', amount)
                                RefreshmarabuntaMoney()
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
            

                    if societyblackmarabuntamoney ~= nil then
                        RageUI.ButtonWithStyle("Argent sale : ", nil, {RightLabel = "$" .. societyblackmarabuntamoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Déposer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                                local count = KeyboardInput("Combien ?", "", 100)
                                TriggerServerEvent('marabunta:putblackmoney', 'item_account', 'black_money', tonumber(count))
                                MDeposerargentsale()
                                ESX.TriggerServerCallback('marabunta:getBlackMoneySociety', function(inventory) 
                            end)
                            RefreshblackmarabuntaMoney()
                        end
                    end)

                    RageUI.ButtonWithStyle("Retirer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local count = KeyboardInput("Combien ?", "", 100)
                            ESX.TriggerServerCallback('marabunta:getBlackMoneySociety', function(inventory) 
                            TriggerServerEvent('marabunta:getItem', 'item_account', 'black_money', tonumber(count))
                            MRetirerargentsale()
                            RefreshblackmarabuntaMoney()
                            end)
                        end
                    end)
                end, function()
            end)
            if not RageUI.Visible(BMarabunta) then
            BMarabunta = RMenu:DeleteType("BMarabunta", true)
        end
    end
end   

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'marabunta' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'marabunta' and ESX.PlayerData.job2.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, marabunta.pos.boss.position.x, marabunta.pos.boss.position.y, marabunta.pos.boss.position.z)
        if dist3 <= 10.0 and marabunta.jeveuxmarker then
            Timer = 0
            DrawMarker(20, marabunta.pos.boss.position.x, marabunta.pos.boss.position.y, marabunta.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 65, 105, 225, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 3.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour accéder aux actions patron", time_display = 1 })
                        if IsControlJustPressed(1,51) then           
                            RefreshmarabuntaMoney()
                            RefreshblackmarabuntaMoney()
                            BossMarabunta()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshmarabuntaMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietymarabuntaMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function RefreshblackmarabuntaMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('marabunta:getBlackMoneySociety', function(inventory)
            UpdateSocietyblackmarabuntaMoney(inventory)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateSocietyblackmarabuntaMoney(inventory)
    societyblackmarabuntamoney = ESX.Math.GroupDigits(inventory.blackMoney)
end

function UpdateSocietymarabuntaMoney(money)
    societymarabuntamoney = ESX.Math.GroupDigits(money)
end

function MDeposerargentsale()
    ESX.TriggerServerCallback('marabunta:getPlayerInventoryBlack', function(inventory)
        while DepositBlackmarabunta do
            Citizen.Wait(0)
        end
    end)
end

function MRetirerargentsale()
	ESX.TriggerServerCallback('marabunta:getBlackMoneySociety', function(inventory)
	    while StockBlackMarabunta do
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