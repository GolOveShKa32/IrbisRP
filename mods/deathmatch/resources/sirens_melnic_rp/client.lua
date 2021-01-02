
local vehicleSirens = {
	[596] = {"sirena.wav"},
}


local minDistance = 30
local maxDistance = 300



addEventHandler("onClientKey",root,function (button,press)
	if button == "h" and press then
		if isPedInVehicle( localPlayer ) and getVehicleController( getPedOccupiedVehicle( localPlayer ) ) == localPlayer then
			local veh = getPedOccupiedVehicle( localPlayer )
		if vehicleSirens[getElementModel(veh)] then
			setElementData(veh,"t_siren",not getElementData(veh,"t_siren"))
		end
	end
end
end)

local sirens = {}

addEventHandler("onClientRender",root,function ()
	for key, veh in ipairs(getElementsByType( "vehicle")) do
		if getElementData(veh,"t_siren") and ( not sirens[veh] ) then
			local x, y, z = getElementPosition(veh)
			sirens[veh] = playSound3D( vehicleSirens[getElementModel(veh)][1], x, y, z, true )
			setSoundMaxDistance( sirens[veh], 	maxDistance )
			setSoundMinDistance( sirens[veh], 	minDistance )
			
		end
		if sirens[veh] and ( not getElementData(veh,"t_siren") ) then
			stopSound(sirens[veh])
			sirens[veh] = nil
		end
		if sirens[veh] and getElementData(veh,"t_siren") then
			local x, y, z = getElementPosition(veh)
			setElementPosition(sirens[veh],x,y,z)
		end
	end
	for key, value in ipairs(sirens) do
		if not isElement(value ) then
			stopSound( value )
			sirens[key] = nil
		end
	end
	end) 