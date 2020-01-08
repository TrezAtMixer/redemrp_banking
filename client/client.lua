RegisterCommand('bank', function(source)

			inMenu = true
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'openGeneral'})
			TriggerServerEvent('redemrp_banking:balance2')
end)

RegisterCommand('closestPlayer', function(source)
	local closestPlayer, closestDistance = GetClosestPlayer()
	print(closestPlayer)
	print(closestDistance)
		
end)

GetPlayers = function()
	local players = {}

	for _,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end

	return players
end

GetClosestPlayer = function(coords)
	local players, closestDistance, closestPlayer = GetPlayers(), -1, -1
	local coords, usePlayerPed = coords, false
	local playerPed, playerId = PlayerPedId(), PlayerId()

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		usePlayerPed = true
		coords = GetEntityCoords(playerPed)
	end

	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])

		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
			local targetCoords = GetEntityCoords(target)
			local distance = #(coords - targetCoords)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer = players[i]
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

--=================Deposit Event===================
local l_ 
local f_ 
RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance, namel, namef)
if namel ~= nil then
 l_ = namel
 f_ = namef
 end
	local playerName = f_.." "..l_

	SendNUIMessage({
		type = "balanceHUD",
		balance = balance,
		player = playerName
		})
end)

--=================Deposit Event======================

RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('redemrp_banking:deposit', tonumber(data.amount))
end)


--==================Withdraw Event====================

RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('redemrp_banking:withdraw', tonumber(data.amountw))
	
end)

RegisterNUICallback('transfer1', function(data)
print("poszlo")
print(data.firstname)
print(data.lastname)
	TriggerServerEvent('redemrp_banking:transfer1', tonumber(data.amountw) , data.firstname, data.lastname)
	
end)
--======================Balance Event======================

RegisterNUICallback('balance', function()
	TriggerServerEvent('redemrp_banking:balance')
end)


--======================NUIFocusoff======================

RegisterNUICallback('NUIFocusOff', function()
	inMenu = false
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
end)
