keys = {
    ['G'] = 0x760A9C6F,
    ['S'] = 0xD27782E3,
    ['W'] = 0x8FD015D8,
	['H'] = 0x24978A28,
	['G'] = 0x5415BE48,
	['E'] = 0xDFF812F9
}

local _inRange=false

RegisterCommand('bank', function(source)
		if (_inRange) then
			inMenu = true
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'openGeneral'})
			TriggerServerEvent('redemrp_banking:balance2')
		else
			TriggerEvent("redemrp_notification:start","You are not near a bank" , 2, "warning")
		end
end)
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


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		for k,v in pairs(Config.Coords) do
			local _distance = Vdist(coords, v)
			if _distance < 5 then
				DrawMarker(-1795314153, v.x, v.y + 0.5, v.z - 1, 0, 0, 0, 0, 0, 0, 1.3, 1.3, .5, 0, 93, 0, 155, 0, 0, 2, 0, 0, 0, 0)
				_inRange=true
			else
				_inRange=false
			end

			if _distance < 2 then
				DrawTxt(Config.Shoptext, 0.50, 0.95, 0.6, 0.6, true, 255, 255, 255, 255, true, 10000)
				if IsControlJustReleased(0, keys['E']) then
					inMenu = true
					SetNuiFocus(true, true)
					SendNUIMessage({type = 'openGeneral'})
					TriggerServerEvent('redemrp_banking:balance2')
				end
			end

		end
	end
end
)

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
	local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
	   SetTextScale(w, h)
	   SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	   SetTextCentre(centre)
	   if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
	   Citizen.InvokeNative(0xADA9255D, 10);
	   DisplayText(str, x, y)
   end

function DrawMarker(hash, x, y, z, dx, dy, dz, rx, ry, rz, sx, sy, sz, r,g ,b, a, bob, face, p19, rotate, tDict, tName, drawOnEnt)
	Citizen.InvokeNative(0x2A32FAA57B937173, hash, x, y, z, dx, dy, dz, rx, ry, rz, sx, sy, sz, r, g, b, a, bob, face, p19, rotate, tDict, tName, drawOnEnt)
end