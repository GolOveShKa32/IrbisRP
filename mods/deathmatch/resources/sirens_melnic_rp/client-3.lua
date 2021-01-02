
local vehiclesirensa = {
	[596] = {"sirena3.mp3"},
}


local minDistance = 30
local maxDistance = 100



addEventHandler("onClientKey",root,function (button,press)
	if button == "x" and press then
		if isPedInVehicle( localPlayer ) and getVehicleController( getPedOccupiedVehicle( localPlayer ) ) == localPlayer then
			local veh = getPedOccupiedVehicle( localPlayer )
		if vehiclesirensa[getElementModel(veh)] then
			setElementData(veh,"l_siren",not getElementData(veh,"l_siren"))
		end
	end
end
end)

local sirensa = {}

addEventHandler("onClientRender",root,function ()
	for key, veh in ipairs(getElementsByType( "vehicle")) do
		if getElementData(veh,"l_siren") and ( not sirensa[veh] ) then
			local x, y, z = getElementPosition(veh)
			sirensa[veh] = playSound3D( vehiclesirensa[getElementModel(veh)][1], x, y, z, true )
			setSoundMaxDistance( sirensa[veh], 	maxDistance )
			setSoundMinDistance( sirensa[veh], 	minDistance )
			
		end
		if sirensa[veh] and ( not getElementData(veh,"l_siren") ) then
			stopSound(sirensa[veh])
			sirensa[veh] = nil
		end
		if sirensa[veh] and getElementData(veh,"l_siren") then
			local x, y, z = getElementPosition(veh)
			setElementPosition(sirensa[veh],x,y,z)
		end
	end
	for key, value in ipairs(sirensa) do
		if not isElement(value ) then
			stopSound( value )
			sirensa[key] = nil
		end
	end
	end) 