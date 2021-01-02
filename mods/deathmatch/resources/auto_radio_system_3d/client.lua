local rd = {}
--local ScreenSize = {}
local Sounds = {}
local radios = {}
                
function startResource(startedResource)
    if startedResource == resource then
    --Окно
        local x, y = guiGetScreenSize()
        local gsx, gsy = 400.0, 200.0
        rd.window = guiCreateWindow(x/2-200, y/1.3, gsx, gsy, "Радио", false)
        guiWindowSetSizable(rd.window, false)
        guiSetAlpha(rd.window, 0.60)
        guiSetProperty(rd.window, "CaptionColour", "FFDE19E5")
    --Список
        rd.gridlist = guiCreateGridList(15, 60, gsx-30, gsy-80, false, rd.window)
        guiSetProperty(rd.gridlist, "ForceVertScrollbar", "True")
        guiGridListAddColumn(rd.gridlist, "#", 0.1)
        guiGridListAddColumn(rd.gridlist, "Название", 0.5)
        guiGridListAddColumn(rd.gridlist, "Жанр", 0.3)
        guiGridListSetSelectionMode(rd.gridlist, 0)
        guiSetAlpha(rd.gridlist, 0.75)
    --Громкость
        rd.scrollbar = guiCreateScrollBar(11, 40, gsx-22, 20, true, false, rd.window)
        guiSetProperty(rd.scrollbar, "MousePassThroughEnabled", "True")
        guiSetAlpha(rd.scrollbar, 0.60)
        --Текст
        rd.label = guiCreateLabel(150, 38, 100, 20, "Громкость", false, rd.window)
        guiSetFont(rd.label, "default-bold-small")
        guiLabelSetColor(rd.label, 222, 25, 229)
        guiLabelSetHorizontalAlign(rd.label, "center", false)
        guiLabelSetVerticalAlign(rd.label, "center")
    --Играет
        rd.curst = guiCreateLabel(150, 20, 100, 20, "Играет", false, rd.window)
        guiSetFont(rd.curst, "default-bold-small")
        guiLabelSetColor(rd.curst, 222, 25, 229)
        guiLabelSetHorizontalAlign(rd.curst, "center", false)
        guiLabelSetVerticalAlign(rd.curst, "center")    
    --Events    
        addEventHandler("onClientGUIDoubleClick", rd.gridlist, onClientGUIClick)
        addEventHandler("onClientGUIScroll", rd.scrollbar, onVolSet)
        addEventHandler("onClientMouseWheel", rd.scrollbar, onVolSetWhell)
        
        bindKey("r","down",RadioChangeGUI)
        triggerServerEvent("GetRadioProperty", getRootElement(), localPlayer)
        triggerServerEvent("GetRadioData", getRootElement(), localPlayer)
        guiSetVisible(rd.window,false)
    end
end
addEventHandler("onClientResourceStart", getRootElement(), startResource)

function onClientGUIClick()
    local selRow = guiGridListGetItemText(rd.gridlist, guiGridListGetSelectedItem(rd.gridlist), 1)
    triggerServerEvent("SetRadio", resourceRoot, localPlayer, tonumber(selRow), getPedOccupiedVehicle(localPlayer), guiScrollBarGetScrollPosition(rd.scrollbar)/100)
end

function onVolSet(Scrolled)
    triggerServerEvent("SetRadio", resourceRoot, localPlayer, nil, getPedOccupiedVehicle(localPlayer), guiScrollBarGetScrollPosition(rd.scrollbar)/100)
end

function onVolSetWhell(upOrDown)
    local vol = guiScrollBarGetScrollPosition(rd.scrollbar)
    if upOrDown == 1 then
        if vol < 97 then
            vol = vol + 3
        end
    else
        if vol > 3 then
            vol = vol - 3
        end
    end
    guiScrollBarSetScrollPosition(rd.scrollbar, vol)
    triggerServerEvent("SetRadio", resourceRoot, localPlayer, nil, getPedOccupiedVehicle(localPlayer), vol/100)
end

function RadioChangeGUI()
    if isPedInVehicle(localPlayer) == true then
        setRadioChannel(0)
        if guiGetVisible(rd.window) == true then
            guiSetVisible(rd.window,false)
            showCursor(false,false)
        else
            guiSetVisible(rd.window,true)
            showCursor(true,true)
        end
    end
end

function SetRadioProperty(vehicleid,radioid,volume)
    if radioid ~= nil then
        stopSound(Sounds[vehicleid])
        Sounds[vehicleid] = playSound3D(tostring(radios[radioid]), 0, 0, 0, false)
        setSoundVolume(Sounds[vehicleid],volume)
        setSoundMaxDistance(Sounds[vehicleid],volume*100)
        attachElements(Sounds[vehicleid], vehicleid)
        guiSetText(rd.curst, guiGridListGetItemText(rd.gridlist, radioid-1, 2))
        --outputChatBox("#FFAF00 Stream title: #FFFFFF"..tostring(guiGridListGetItemText(rd.gridlist, radioid-1, 2)), 255, 255, 255, true )
        --outputChatBox("#FFAF00 Stream name: #FFFFFF"..tostring(meta.stream_name), 255, 255, 255, true )
    end
end
addEvent("SetRadioProperty",true)
addEventHandler("SetRadioProperty",getRootElement(),SetRadioProperty)

function SetRadioData(RadiosArray)
    local str
    for i in ipairs(RadiosArray) do
        str = split(RadiosArray[i],"|")
        radios[i] = str[1]
        local row = guiGridListAddRow(rd.gridlist)
        guiGridListSetItemText(rd.gridlist, row, 1, tostring(i), false, false)
        guiGridListSetItemText(rd.gridlist, row, 2, str[2], false, false)
        guiGridListSetItemText(rd.gridlist, row, 3, str[3], false, false)
    end
end
addEvent("SetRadioData",true)
addEventHandler("SetRadioData",getRootElement(),SetRadioData)


function DestroySound(vehicleid)
    stopSound(Sounds[vehicleid])
    Sounds[vehicleid] = nil
end

addEvent("DestroySound",true)
addEventHandler("DestroySound",getRootElement(),DestroySound)