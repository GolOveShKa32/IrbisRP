



localChatSet = { --- локальный чат
    ['radius'] = 15, --- радиус видимости 
    ['color1'] = '#FFFFFF', ---- цвет текста в радиусе выше / 4 т.е 15/4
    ['color2'] = '#aba9ae', ---- цвет текста в радиусе выше /3 т.е 15/3
    ['color3'] = '#8b8b8b', ---- цвет текста в радиусе выше /2 т.е 15/2
    ['color4'] = '#746d73', ---- цвет текста в радиусе выше  т.е 15
    ['symbols'] = 50, ---- кол-во символов в 1 строке
    ['height'] = 1.1, --- высота над головой
    ['heightSecondLine'] = 1.2, --- высота второй строки ( над головой )
    ['heightThirdLine'] = 1.3, --- высота 3 строки ( над головой )
    ['secondLineN'] = 40, --- если символов больше этого значения текст перенесётся на вторую строку
    ['thirdLineN'] = 80, --- если символов больше этого значения текст перенесётся на третью строку
}

loud = { --- крик
    ['radius'] = 30, -- радиус видимости
    ['color1'] = '#FFFFFF', --- цвет вблизи ( радиус выше /2 )
    ['color2'] = '#91918f', --- цвет вдали ( радиус выше )
    ['symbols'] = 50, --- кол-во символов в 1 строке
}

moreLoud = { --- громкий крик
    ['radius'] = 60, -- радиус видимости
    ['color1'] = '#FFFFFF', --- цвет вблизи ( радиус выше /2 )
    ['color2'] = '#91918f', --- цвет вдали ( радиус выше )
    ['symbols'] = 50, --- кол-во символов в 1 строке
}

whisper = { --- шёпот
    ['radius'] = 5, -- радиус видимости
    ['color1'] = '#a6a2a3', --- цвет 
    ['symbols'] = 50, --- кол-во символов в 1 строке
}

me = { -- /me
    ['radius'] = 15, -- радиус видимости
    ['color1'] = '#f65782', -- цвет
    ['symbols'] = 50, --- кол-во символов в 1 строке
}

doCommand = { --- /do
    ['radius'] = 15, -- радиус видимости
    ['color1'] = '#f65782', -- цвет
    ['symbols'] = 50, --- кол-во символов в 1 строке
}

bCommand = {  --- /b
    ['radius'] = 15, -- радиус видимости
    ['color1'] = '#FFFFFF', -- цвет
    ['symbols'] = 50, --- кол-во символов в 1 строке
    ['floodBlock'] = 3000, --- время блока от флуда в милисекундах

}


pm = { --  /pm
    ['color1'] = '#f2cc23', -- цвет
    ['symbols'] = 50, --- кол-во символов в 1 строке
    ['floodBlock'] = 3000, --- время блока от флуда в милисекундах
}

action = { --- /action
    ['radius'] = 20, -- радиус видимости
    ['color1'] = '#f65782', -- цвет
    ['symbols'] = 60, --- кол-во символов в 1 строке
}

ab = { --- /ab
    ['radius'] = 20, -- радиус видимости
    ['color1'] = '#FFFFFF', -- цвет
    ['height'] = 1.1, --- высота над головой
    ['symbols'] = 50, --- кол-во символов в 1 строке
}

ame = { --- /ame
    ['radius'] = 20, -- радиус видимости
    ['color1'] = '#f05986', -- цвет
    ['height'] = 1.1, --- высота над головой
    ['symbols'] = 50, --- кол-во символов в 1 строке
}

--- /me + /do + /b + /s +  /w +  /local - переносятся

--- не переносятся остальные - /pm /ab /ame /pame /mypame /action 

--- ограничения по символам --------
-- /me /do /b /s /w /local  - 120 символов с переносом
-- /ame + /ab + /pm + - 50 символов 
-- /action + - 60 символов


function dxDraw3DText(text, x, y, z, scale, font, color, maxDistance, colorCoded, owner)
    if not (x and y and z) then
        outputDebugString("dxDraw3DText: One of the world coordinates is missing", 1);
        return false;
    end

    if not (scale) then
        scale = 2;
    end
    
    if not (font) then
        font = "default";
    end
    
    if not (color) then
        color = tocolor(255, 255, 255, 255);
    end
    
    if not (maxDistance) then
        maxDistance = 12;
    end
    
    if not (colorCoded) then
        colorCoded = false;
    end

    if not owner then 
        owner = '';
    end
    
    local pX, pY, pZ = getElementPosition( localPlayer );   
    local distance = getDistanceBetweenPoints3D(pX, pY, pZ, x, y, z);
            
    if (distance <= maxDistance) then
        local x, y = getScreenFromWorldPosition(x, y, z);
        if (x and y) then
            if owner then 
                if localPlayer ~= owner then 
                    dxDrawText( text, x, y, _, _, color, scale, font, "center", "center", false, false, false, colorCoded);
                end
            end
            return true;
        end
    end
end
