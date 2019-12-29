RegisterServerEvent('redemrp_banking:withdraw')
AddEventHandler('redemrp_banking:withdraw', function(amount)
    local _source = source
    local base = 0
	local _amount = tonumber(amount)
	--print(amount)
	if amount ~= nil then
    TriggerEvent('redemrp:getPlayerFromId', source, function(user)
        local identifier = user.getIdentifier()
        local charid = user.getSessionVar("charid")

        TriggerEvent("getBankMoney", identifier, charid, function(call)
            base = call
            if _amount == nil or _amount <= 0 or _amount > base then
                 TriggerClientEvent("redemrp_notification:start",_source, "Invalid amount" , 2, "error")
            else
                user.addMoney(_amount)
				TriggerEvent('removeBankMoney',_source, _amount)	
                TriggerClientEvent("redemrp_notification:start",_source, "Withdrawal made.." , 2, "success")
				Wait(1000)
				TriggerEvent('redemrp_banking:balance',_source)

            end
        end)
    end)
	end
end)

RegisterServerEvent('redemrp_banking:deposit')
AddEventHandler('redemrp_banking:deposit', function(amount)
    local _source = source
	local _amount = tonumber(amount)
	if amount ~= nil then
    TriggerEvent('redemrp:getPlayerFromId', source, function(user)
        local currentMoney = user.getMoney()
        if _amount == nil or _amount <= 0 or _amount > currentMoney then
           TriggerClientEvent("redemrp_notification:start",_source, "Invalid amount" , 2, "error")
        else
            user.removeMoney(_amount)
			TriggerEvent('addBankMoney',_source, _amount)
            TriggerClientEvent("redemrp_notification:start",_source, "Deposit made." , 2, "success")
			Wait(1000)
			TriggerEvent('redemrp_banking:balance',_source)
        end
    end)
	end
end)

RegisterServerEvent('redemrp_banking:balance')
AddEventHandler('redemrp_banking:balance', function(source)
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        local identifier = user.getIdentifier()
        local charid = user.getSessionVar("charid")
        TriggerEvent("getBankMoney", identifier, charid, function(call)
           TriggerClientEvent('currentbalance1', _source, call ,namel, namef)
			

        end)
    end)
end)

RegisterServerEvent('redemrp_banking:balance2')
AddEventHandler('redemrp_banking:balance2', function()
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', source, function(user)
        local identifier = user.getIdentifier()
        local charid = user.getSessionVar("charid")
		local namel = user.getLastname()
		local namef = user.getFirstname()
	--	print(namel)
	--	print(namef)
        TriggerEvent("getBankMoney", identifier, charid, function(call)
         TriggerClientEvent('currentbalance1', _source, call ,namel, namef)
			

        end)
    end)
end)


AddEventHandler('getBankMoney', function(identifier, charid, callback)
    local Callback = callback
    MySQL.Async.fetchAll('SELECT bank FROM characters WHERE `identifier`=@identifier AND `characterid`=@characterid;', {identifier = identifier, characterid = charid}, function(money)
        if money[1]then
            bank = money[1].bank
            Callback(bank)
        end
    end)
end)


AddEventHandler('removeBankMoney', function(source, amount)
		
		       local _amount = amount
    TriggerEvent('redemrp:getPlayerFromId', source, function(user)
        local identifier = user.getIdentifier()
        local charid = user.getSessionVar("charid")
        local bankmoney = 0
        MySQL.Async.fetchAll('SELECT bank FROM characters WHERE `identifier`=@identifier AND `characterid`=@characterid;', {identifier = identifier, characterid = charid}, function(money)
            if money[1]then
                bank = money[1].bank
              
            end
			Wait(500)
            if (bank-_amount) < 0 then
                bankmoney = 0
            else
                bankmoney = bank-_amount
            end
            MySQL.Async.execute("UPDATE characters SET `bank`='" .. bankmoney .. "' WHERE `identifier`=@identifier AND `characterid`=@characterid", {identifier = identifier, characterid = charid}, function(done)
                end)

        end)
    end)
end)


AddEventHandler('addBankMoney', function(source, amount)
    TriggerEvent('redemrp:getPlayerFromId', source, function(user)
        local identifier = user.getIdentifier()
        local charid = user.getSessionVar("charid")
        local _amount = amount
        local bankmoney = 0
        MySQL.Async.fetchAll('SELECT bank FROM characters WHERE `identifier`=@identifier AND `characterid`=@characterid;', {identifier = identifier, characterid = charid}, function(money)
            if money[1]then
                bank = money[1].bank
               
            end
            local bankmoney =  bank+_amount
            MySQL.Async.execute("UPDATE characters SET `bank`='" .. bankmoney .. "' WHERE `identifier`=@identifier AND `characterid`=@characterid", {identifier = identifier, characterid = charid}, function(done)
                end)

        end)
    end)
end)
