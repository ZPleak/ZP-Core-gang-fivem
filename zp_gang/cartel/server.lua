ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'cartel', 'alerte cartel', true, true)

TriggerEvent('esx_society:registerSociety', 'cartel', 'cartel', 'society_cartel', 'society_cartel', 'society_cartel', 'society_cartel_black', {type = 'public'})

ESX.RegisterServerCallback('cartel:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cartel', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('cartel:getStockItem')
AddEventHandler('cartel:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cartel', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, 'Objet retiré', count, inventoryItem.label)
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)

RegisterServerEvent('vInventory:Boss_recruterplayer')
AddEventHandler('vInventory:Boss_recruterplayer', function(target, job2, grade)
  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if sourceXPlayer.job2.grade_name == 'boss' then
    targetXPlayer.setJob2(job2, grade)
    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~recruté ' .. targetXPlayer.name .. '~w~.')
    TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~g~embauché par ' .. sourceXPlayer.name .. '~w~.')
  end
end)

RegisterServerEvent('vInventory:Boss_virerplayer')
 AddEventHandler('vInventory:Boss_virerplayer', function(target)
 	local sourceXPlayer = ESX.GetPlayerFromId(source)
 	local targetXPlayer = ESX.GetPlayerFromId(target)

 	if sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
 		targetXPlayer.setJob2('unemployed', 0)
 		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~viré ' .. targetXPlayer.name .. '~w~.')
 		TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~g~viré par ' .. sourceXPlayer.name .. '~w~.')
 	end
end)

RegisterServerEvent('vInventory:Boss_promouvoirplayer')
AddEventHandler('vInventory:Boss_promouvoirplayer', function(target)
  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)
  if sourceXPlayer.job2.grade_name == 'boss' then
      targetXPlayer.setJob2(targetXPlayer.job2.name, tonumber(targetXPlayer.job2.grade) + 1)

      TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~promu ' .. targetXPlayer.name .. '~w~.')
      TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~g~promu par ' .. sourceXPlayer.name .. '~w~.')
  end
end)

ESX.RegisterServerCallback('cartel:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterNetEvent('cartel:putStockItems')
AddEventHandler('cartel:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cartel', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification(_U('have_deposited', count, inventoryItem.name))
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)

ESX.RegisterServerCallback('cartel:getPlayerInventoryBlack', function(source, cb)
	local _source = source
	local xPlayer    = ESX.GetPlayerFromId(_source)
	local blackMoney = xPlayer.getAccount('black_money').money
  
	cb({
	  blackMoney = blackMoney
	})
  end)

RegisterServerEvent('cartel:putblackmoney')
AddEventHandler('cartel:putblackmoney', function(type, item, count)

  local _source      = source
  local xPlayer      = ESX.GetPlayerFromId(_source)

  if type == 'item_account' then
    local playerAccountMoney = xPlayer.getAccount(item).money

    if playerAccountMoney >= count then

      xPlayer.removeAccountMoney(item, count)
      TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cartel_black', function(account)
        account.addMoney(count)
      end)
    else
      TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
    end
  end
end)


  ESX.RegisterServerCallback('cartel:getBlackMoneySociety', function(source, cb)
    local _source = source
    local xPlayer    = ESX.GetPlayerFromId(_source)
    local blackMoney = 0
  
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cartel_black', function(account)
      blackMoney = account.money
    end)
  
    cb({
      blackMoney = blackMoney
    })
  
  end)

  RegisterServerEvent('cartel:getItem')
  AddEventHandler('cartel:getItem', function(type, item, count)
  
    local _source      = source
    local xPlayer      = ESX.GetPlayerFromId(_source)
  
    if type == 'item_account' then
  
      TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cartel_black', function(account)
  
        local roomAccountMoney = account.money
  
        if roomAccountMoney >= count then
          account.removeMoney(count)
          xPlayer.addAccountMoney(item, count)
        else
          TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
        end
  
      end)
    end
end)