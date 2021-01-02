local marker = createMarker(2141,-2236,38, "cylinder", 2, 255, 0, 0, 200)
setElementData(marker, "markerhueta", true)

function onPharmacy (pharmacyName)
	loadstring (exports.dgs:dgsImportFunction ())()

	local sW, sH = guiGetScreenSize ()
	local wW, wH = 720, 540

	showCursor (true)

	local med = dgsCreateFont ("HelveticaMedium.ttf", 10)
	local font18 = dgsCreateFont ("HelveticaRegular.ttf", 10)
	local font12 = dgsCreateFont ("HelveticaRegular.ttf", 10)

	local close_txt = dxCreateTexture ("close.png")

	local window = dgsCreateWindow ((sW - wW) / 2, (sH - wH) / 2, wW, wH, "Аптека"..' - "'..pharmacyName..'"', false, 0xFFE0E0E0, 28, nil, 0xCC000000, nil, 0x00101010, 5, false)
	dgsWindowSetSizable (window, false)
	dgsWindowSetMovable (window, false)
	dgsSetFont(window, font18)

	local closeButton = dgsWindowGetCloseButton(window)
	local closeButtonBg = dxCreateTexture("close.png")
	dgsSetProperty(closeButton, "image", { closeButtonBg, closeButtonBg, closeButtonBg })
	dgsSetProperty(closeButton, "text", "")
	dgsSetProperty(closeButton, "color", { 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF })
	dgsSetPosition(closeButton, 28, 0, false)
	dgsSetSize(closeButton, 28, 28, false)

	addEventHandler("onClientMarkerHit", marker, function(_, state)
		showCursor(true)
		dgsSetVisible(window, true)
	end)

	addEventHandler("onDgsWindowClose", window,
	function(_, state)
		cancelEvent()
		showCursor(false)
		dgsSetVisible(window, false)
	end)

	local bg = dgsCreateImage (0, 0, 720, 512, "bg.png", false, window)

	--local title = dgsCreateLabel (40, 0, wW - 80, 90, "Аптека"..' - "'..pharmacyName..'"', false, window, _, _, _, _, _, _, "left", "center")
	--dgsSetFont (title, font18)

	--local close = dgsCreateButton (wW - 60, 35, 20, 20, "", false, window, _, _, _, close_txt, close_txt, close_txt, tocolor (255, 255, 255, 153), tocolor (255, 255, 255, 255), tocolor (255, 255, 255, 255))

	local names = {}
	local info = {}
	local buy = {}
	local imgs = {}
	local m = {}

	names[1] = dgsCreateLabel (21, 27, 218, 40, MEDS[1][1], false, window, _, _, _, _, _, _, "center", "center")
	names[2] = dgsCreateLabel (251, 27, 218, 40, MEDS[2][1], false, window, _, _, _, _, _, _, "center", "center")
	names[3] = dgsCreateLabel (481, 27, 218, 40, MEDS[3][1], false, window, _, _, _, _, _, _, "center", "center")
	names[4] = dgsCreateLabel (21, 274, 218, 40, MEDS[4][1], false, window, _, _, _, _, _, _, "center", "center")
	names[5] = dgsCreateLabel (251, 274, 218, 40, MEDS[5][1], false, window, _, _, _, _, _, _, "center", "center")

	
	info[1] = dgsCreateLabel (21, 200, 218, 40, "Здоровье: ".."+"..MEDS[1][2].." ("..MEDS[1][3].." р.)", false, window, _, _, _, _, _, _, "center", "center")
	info[2] = dgsCreateLabel (251, 200, 218, 40, "Здоровье: ".."+"..MEDS[2][2].." ("..MEDS[2][3].." р.)", false, window, _, _, _, _, _, _, "center", "center")
	info[3] = dgsCreateLabel (481, 200, 218, 40, "Здоровье: ".."+"..MEDS[3][2].." ("..MEDS[3][3].." р.)", false, window, _, _, _, _, _, _, "center", "center")
	info[4] = dgsCreateLabel (21, 447, 218, 40, "Здоровье: ".."+"..MEDS[4][2].." ("..MEDS[4][3].." р.)", false, window, _, _, _, _, _, _, "center", "center")
	info[5] = dgsCreateLabel (251, 447, 218, 40, "Здоровье: ".."+"..MEDS[5][2].." ("..MEDS[5][3].." р.)", false, window, _, _, _, _, _, _, "center", "center")
	
	buy[1] = dgsCreateButton (50, 174, 160, 26, "Купить", false, window, 0xFFE0E0E0, 1, 1, nil, nil, nil, 0x00181818, 0xFF303030, 0xFFA00000)
	buy[2] = dgsCreateButton (280, 174, 160, 26, "Купить", false, window, 0xFFE0E0E0, 1, 1, nil, nil, nil, 0x00181818, 0xFF303030, 0xFFA00000)
	buy[3] = dgsCreateButton (510, 174, 160, 26, "Купить", false, window, 0xFFE0E0E0, 1, 1, nil, nil, nil, 0x00181818, 0xFF303030, 0xFFA00000)
	buy[4] = dgsCreateButton (50, 420, 160, 30, "Купить", false, window, 0xFFE0E0E0, 1, 1, nil, nil, nil, 0x00181818, 0xFF303030, 0xFFA00000)
	buy[5] = dgsCreateButton (280, 420, 160, 30, "Купить", false, window, 0xFFE0E0E0, 1, 1, nil, nil, nil, 0x00181818, 0xFF303030, 0xFFA00000)
	
	imgs[1] = dgsCreateImage (100, 100, 60, 60, "img/1.png", false, window)
	imgs[2] = dgsCreateImage (330, 100, 60, 60, "img/2.png", false, window)
	imgs[3] = dgsCreateImage (560, 100, 60, 60, "img/3.png", false, window)
	imgs[4] = dgsCreateImage (100, 346, 60, 60, "img/4.png", false, window)
	imgs[5] = dgsCreateImage (330, 346, 60, 60, "img/5.png", false, window)

	for i = 1, 5 do
		dgsSetFont (names[i], med)
		dgsSetFont (info[i], font18)
		dgsSetFont (buy[i], font18)
		m[i] = dxCreateTexture ("img/"..i..".png")

		addEventHandler ("onDgsMouseClick", buy[i], function (button, state)
			if button == "left" and state == "down" then
				if getPlayerMoney () >= MEDS[i][3] then
					takePlayerMoney (MEDS[i][3])
					setElementHealth (localPlayer, getElementHealth (localPlayer) + MEDS[i][2])
					outputChatBox ('Вы приобрели "'..MEDS[i][1]..'" за '..MEDS[i][3].." рублей.", 0, 255, 0)
				else
					outputChatBox ("Недостаточно средств.", 255, 0, 0)
				end
			end
		end, false)
	end

	local warn = dgsCreateLabel (481, 271, 218, 218, "", false, window, _, _, _, _, _, _, "center", "center")
	local warn_text = "Лечебные препараты увеличивают Ваш уровень здоровья.\n\nЧрезмерное использование лечебных препаратов может привести к\nтошноте, вздутию, головной боли."
	dgsSetText (warn, warn_text)
	dgsSetFont (warn, font12)
	dgsSetProperty (warn, "wordbreak", true)
end

addEvent ("onPharmacy", true)
addEventHandler ("onPharmacy", localPlayer, onPharmacy)



